local core = require('core')

local TestResult = core.Object:extend()

function TestResult:message()
  return self._message
end
function TestResult:set_message(message)
  self._message = message
  return self
end

function TestResult:severity()
  return self._severity
end
function TestResult:set_severity(severity)
  self._severity = severity
  return self
end

function TestResult:got()
  return self._got
end
function TestResult:set_got(got)
  self._got = got
  return self
end

function TestResult:expected()
  return self._expected
end
function TestResult:set_expected(expected)
  self._expected = expected
  return self
end

return TestResult
