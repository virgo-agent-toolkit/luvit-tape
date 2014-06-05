local table = require('table')
local io = require('io')

local Writable = require('stream').Writable

local TestSuite = require('./lib/test_suite').TestSuite
local TapProducer = require('./lib/tap_producer').TapProducer
local TestRunner = require('./lib/test_runner').TestRunner

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
  return function(test_name, conf, func)
    if not triggered then
      process.nextTick(trigger)
      triggered = true
    end
    suite:test(test_name, conf, func)
  end
end

local stdout = Writable:extend()

function stdout:_write(data, encoding, callback)
  if data then
    io.write(data)
  end
  callback()
end

function trigger()
  local current = first
  local count = 1
  function go()
    if current then
      local producer = TapProducer:new()
      producer:once('end', go)
      current:pipe(TestRunner:new(), {_end = true}):pipe(producer, {_end = true}):pipe(stdout:new())
      current = current.next_suite
    end
  end
  go()
end

return test
