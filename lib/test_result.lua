local core = require('core')

local TestResult = core.Object:extend()

-- get or set the message
-- message (optional): string
function TestResult:message(message)
  if message == nil then
    return self._message
  else
    self._message = message
    return self
  end
end

-- get or set the severity
-- severity (optional): string
function TestResult:severity(severity)
  if severity == nil then
    return self._severity
  else
    self._severity = severity
    return self
  end
end

-- get or set the data got
-- severity (optional): anything
function TestResult:got(got)
  if got == nil then
    return self._got
  else
    self._got = got
    return self
  end
end

-- get or set the data expected
-- expected (optional): anything
function TestResult:expected(expected)
  if expected == nil then
    return self._expected
  else
    self._expected = expected
    return self
  end
end

return TestResult
