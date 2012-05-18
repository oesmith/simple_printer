require 'sinatra'
require 'redis'

require 'a2_printer'

redis = Redis.new

get '/post/:id' do
  haml :index
end

post '/post/:id' do
  data = StringIO.new
  writer = A2Printer.new(data)
  writer.begin
  writer.set_default
  if params[:title]
    writer.set_size :medium
    writer.print "#{params[:title]}"
    writer.feed 1
  end
  if params[:body]
    writer.set_size :small
    writer.print "#{params[:body]}"
    writer.feed 1
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

