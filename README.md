# simple printer

This is a really, *really* simple print server designed for use with arduinos
hooked up to thermal receipt printers.

It's a basic sinatra+redis app that queues print jobs.  Print devices poll an
endpoint associated with their unique ID.  Jobs can be queued by POSTing to
the same endpoint.

__Hint: check the debug output of the device or the sinatra logs to discover
the IDs/URLs.__

## Example

To push a simple text job:

    curl -D - -X POST --data-binary 'Hello, World!' http://localhost:4567/printer/{PRINTER ID HERE}

## Further reading

- https://github.com/oesmith/a2_printer
  for formatting print jobs beyond simple ASCII text
- https://github.com/oesmith/printer_sketch
  for code to put on your Arduino

## Thanks

- lazyatom (James Adam) for his work, from which this is massively
  derivative.
- the awesome engineering team at Wildfire Interactive in London.

