require 'a2_printer'

data = StringIO.new
printer = A2Printer.new(data)
printer.begin
printer.set_default
printer.print_image('logo.png')

File.open('logo1', 'w').write(data.string)

