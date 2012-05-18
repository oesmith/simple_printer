require 'sinatra'
require 'redis'

require 'a2_printer'

redis = Redis.new

get '/' do
  haml :index
end

post '/' do
  data = StringIO.new
  writer = A2Printer.new(data)
  writer.begin
  writer.set_default
  if params[:title]
    writer.set_size :large
    writer.print "#{params[:title]}\r\n"
  end
  if params[:subtitle]
    writer.set_size :small
    writer.print "#{params[:subtitle]}\r\n"
  end
  if params[:type] && params[:barcode]
    writer.feed 1
    writer.print_barcode params[:barcode], params[:type].to_i
  end
  if params[:id]
    writer.feed 2
    writer.flush
    redis.rpush("printer:#{params[:id]}", data.string)
  end
  haml :done
end

post '/printer/:id' do
  request.body.rewind
  data = request.body.read
  if data.length == 0
    400
  else
    redis.rpush("printer:#{params[:id]}", data+"\x0a\x0a\x0a\x0a\x0b")
    204
  end
end

get '/printer/:id' do
  data = redis.lpop("printer:#{params[:id]}")
  if data.nil?
    204
  else
    [200, data]
  end
end

error do
  ''
end

