local table = require('table')

local TestSuite = require('./lib/test_suite').TestSuite
local TapTransform = require('./lib/tap_transform').TapTransform

local last = nil
local first = nil
local triggered = false

function test(test_suite_name)
  local suite = TestSuite:new(test_suite_name)
  if first == nil then
    first = suite
  end
  if last ~= nil then
    last.next_suite = suite
  end
  last = suite
  return function(test_name, callback)
    if not triggered then
      process.nextTick(trigger)
      triggered = true
    end
    suite:test(test_name, callback)
  end
end

function trigger()
  local current = first
  local count = 1
  function go()
    if current then
      current:pipe(TapTransform:new()):pipe(process.stdout)
      current:go(go)
      current = current.nextSuite
    end
  end
  go()
end

return test
