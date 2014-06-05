local core = require('core')
local TestResult = require('./test_result').TestResult

local Test = core.Object:extend()

function Test:initialize(name, conf, func)
  self.name = name
  self.conf = conf
  self.func = func

  self.id = 0
  self.result = TestResult:new()
  self.ok = true
  self.finished = false
end

function Test:is_number(a, message)
  if self.finished or not self.ok then
    return
  end

  if type(a) ~= 'number' then
    self.ok = false
    self.result:message(message):severity('fail'):got(a):expected('a number')
  end
end

function Test:equal(expected, got, message)
  if self.finished or not self.ok then
    return
  end

  local _equal = function(a, b)
    if a == b then
      return true
    end

    if type(a) == 'table' and type(b) == 'table' then
      -- todo
    end

    return false
  end

  if not _equal(expected, got) then
    self.ok = false
    self.result:message(message):severity('fail'):got(b):expected(a)
  end

end

local exports = {}

exports.Test = Test

return exports
