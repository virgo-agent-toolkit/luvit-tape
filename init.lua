local TestSuites = require('./lib/test_suites.lua').TestSuites
local TestSuitesRunner = require('./lib/test_suites.lua').TestSuitesRunner
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

-- Test suites are triggered in the next tick
process.nextTick(function()
  suites:pipe(TestSuitesRunner:new())
end)

-- all test functions should be passed in within the first tick
return function(test_suite_name)
  local suite = suites:get_or_create_suite(test_suite_name)
  return function(test_name, conf, func)
    suite:test(test_name, conf, func)
  end
end
