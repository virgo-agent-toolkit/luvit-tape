local tape = require('..')
local DumpingWriter = require('./dumping_writer').DumpingWriter

local runner = tape.TestRunner:new()

runner:test("test 1", function(t, cb)
  t:is_number(1, "1 should be a number")
  t:is_number({}, "is {} a number?")
  cb()
end)

runner:pipe(DumpingWriter:new())

runner:go()
