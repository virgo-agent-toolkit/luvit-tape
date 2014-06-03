local core = require('core')
local Test = require('./test').Test
local stream = require('../modules/stream')
local table = require('table')

local TestSuite = stream.Readable:extend()

function TestSuite:initialize(suite_name)
  stream.Readable.initialize(self, {objectMode = true, highWaterMark = 1024})
  self.suite_name = suite_name
  self.currentTestID = 1
  self.tests = {}
  self.read_called = false
end

function TestSuite:_read(n)
  self.read_called = true
  for i = 1,n,1 do
    if table.getn(self.tests) ~= 0 then
      self:push(table.remove(self.tests, 1))
    else
      self:push(nil)
    end
  end
end

function TestSuite:test(name, conf, func)
  if self.read_called then
    debug('warning: test() called after _read() is called.')
  end

  if type(conf) == 'function' then
    func = conf
    conf = nil
  end
  if type(name) == 'object' then
    conf = name
    name = nil
  end
  if type(name) == 'function' then
    func = name
    name = nil
  end

  if not conf then conf = {} end
  if not name then name = '' end

  local t = Test:new(name, conf, func)
  t.id = self.currentTestID
  self.currentTestID = self.currentTestID + 1
  table.insert(self.tests, t)
end

local exports = {}

exports.TestSuite = TestSuite

return exports