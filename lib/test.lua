local core = require('core')
local TestResult = require('./test_result').TestResult

local Test = core.Object:extend()

function Test:initialize(name, conf)
  self.name = name
  self.conf = conf

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

local exports = {}

exports.Test = Test

return exports
