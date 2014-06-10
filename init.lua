local TestSuites = require('./lib/test_suites.lua').TestSuites
local TestSuitesRunner = require('./lib/test_suites.lua').TestSuitesRunner

local suites = TestSuites:new()


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
