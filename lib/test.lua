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

  self.directives = {}
  self.directives['skip'] = { skipped = false, reason = "" }
  self.directives['todo'] = { is_todo = false, explanation = "" }
end

function Test:todo(explanation)
  -- no matter it's finished/ok or not, TODO directive should be shown.
  -- TODO directive is not show if the test has been skipped
  if not self.directives['skip'].skipped then
    self.directives['todo'].is_todo = true
    self.directives['todo'].explanation = explanation
    self.ok = false -- TODO tests are considered failed
    self:finish()
  end
end

function Test:skip(reason)
  if self.finished or not self.ok then
    return
  end
  self.directives['skip'].skipped = true
  self.directives['skip'].reason = reason
  self:finish()
end

function Test:finish()
  if not self.finished then
    self.finished = true
    self:_finish()
  end
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
