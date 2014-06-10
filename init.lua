local TestSuites = require('./lib/test_suites.lua').TestSuites
local TestSuitesRunner = require('./lib/test_suites.lua').TestSuitesRunner

local suites = TestSuites:new()


process.nextTick(function()
  suites:pipe(TestSuitesRunner:new())
end)

return function(test_suite_name)
  local suite = suites:new_suite(test_suite_name)
  return function(test_name, conf, func)
    suite:test(test_name, conf, func)
  end
end
