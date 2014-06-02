local tape = require('..')

local runner = tape.TestRunner:new()

runner:test("My super awesome test", function(t, cb)
  t:is_number(1, "1 should be a number")
  t:is_number(2, "2 should be a number")
  cb()
end)

runner:test("My super awesome test", function(t, cb)
  t:is_number(42, "42 should be a number")
  t:is_number({}, "is {} a number?")
  cb()
end)

runner:pipe(tape.TapTransform:new()):pipe(process.stdout)

runner:go()
