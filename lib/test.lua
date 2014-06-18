local core = require('core')
local TestResult = require('./test_result').TestResult
local stats = require('./stats')

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
  if self.directives['skip'].skipped then
    return
  end

  self.directives['todo'].is_todo = true
  self.directives['todo'].explanation = explanation
  self.ok = false -- TODO tests are considered failed
  self:finish()
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
  if self.finished then
    return
  end

  self.finished = true
  if not self.ok then
    stats.failedTests = stats.failedTests + 1
  end
  self:_finish()
end

function Test:_assert(cb)
  if self.finished or not self.ok then
    return
  end

  cb()
end

function Test:is_nil(a, message)
  self:_assert(function()
    if a ~= nil then
      self.ok = false
      self.result:set_message(message):set_severity('fail'):set_got(a):set_expected(nil)
    end
  end)
end

function Test:not_nil(a, message)
  self:_assert(function()
    if a == nil then
      self.ok = false
      self.result:set_message(message):set_severity('fail'):set_got(a):set_expected(nil)
    end
  end)
end

function Test:is_x(x, a, message)
  self:_assert(function()
    if type(a) ~= x then
      self.ok = false
      self.result:set_message(message):set_severity('fail'):set_got(a):set_expected('a ' .. x)
    end
  end)
end

function Test:is_number(a, message)
  self:is_x('number', a, message)
end

function Test:is_string(a, message)
  self:is_x('string', a, message)
end

function Test:is_boolean(a, message)
  self:is_x('boolean', a, message)
end

function Test:is_table(a, message)
  self:is_x('table', a, message)
end

function Test:is_array(a, message)
  self:_assert(function()
    local nope = function()
      self.ok = false
      self.result:set_message(message):set_severity('fail'):set_got(a):set_expected('a ' .. x)
    end

    if type(a) ~= 'table' then
      nope()
      return
    end

    local is_array = true
    local i = 1
    for k,v in pairs(a) do
      if not (k == i) then
        is_array = false
        nope()
        return
      end
      i = i + 1
    end
  end)
end

function Test:equal(expected, got, message)
  local function _equal(a, b)
    if a == b then
      -- same value or same reference
      return true
    end

    if type(a) == 'table' and type(b) == 'table' then
      local keys = {}
      local count = 0
      for k,v in pairs(a) do
        keys[k] = true
        count = count + 1
      end
      for k,v in pairs(b) do
        if not keys[k] then
          -- b has a key not in a
          return false
        end
        count = count - 1
      end

      if count ~= 0 then
        -- b has less keys than a
        return false
      end

      -- a and b have same keys set. deep compare them
      for k,v in pairs(keys) do
        if not _equal(a[k], b[k]) then
          return false
        end
      end

      return true
    end

    return false
  end

  self:_assert(function()
    if not _equal(expected, got) then
      self.ok = false
      self.result:set_message(message):set_severity('fail'):set_got(got):set_expected(expected)
    end
  end)
end

local exports = {}

exports.Test = Test

return exports
