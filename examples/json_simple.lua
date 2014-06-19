local TestSuite = require('../lib/test_suite')
local Runner = require('../lib/runner')
local JSONDumper = require('./json_dumper')

local suite = TestSuite:new()

suite:test("My awesome test", nil, function(t)
  t:is_number(1, "1 should be a number")
  t:is_number(2, "2 should be a number")
  t:finish()
end)

suite:test("My super awesome test", nil, function(t)
  t:is_number(42, "42 should be a number")
  t:is_number({}, "is {} a number?")
  t:finish()
end)

suite:pipe(Runner:new()):pipe(JSONDumper:new()):pipe(process.stdout)
