local TestSuites = require('./lib/test_suites.lua')
local Runner = require('./lib/runner')
local utils = require('utils')
local stats = require('./lib/stats')

local suites = TestSuites:new()

-- reflect number of failed tests aggregated from all test suites in exit code.
process:on('exit', function(exit_code)
  if stats.failedTests > 255 then
    process.exit(255)
  else
    process.exit(stats.failedTests)
  end
end)

local Sink = require('stream').Writable:extend()

function Sink:initialize()
  require('stream').Writable.initialize(Sink, {objectMode = true})
end

function Sink:_write(data, encoding, cb)
  cb()
end

-- Test suites are triggered in the next tick
process.nextTick(function()
  local runner = Runner:new()
  suites:pipe(runner):pipe(Sink:new())
  -- suites:pipe(runner)
  -- runner:resume() -- trigger flow mode so that no consumer is needed
end)

-- all test functions should be passed in within the first tick
return function(test_suite_name)
  local suite = suites:get_or_create_suite(test_suite_name)
  return utils.bind(suite.test, suite)
end
