local table = require('table')
local core = require('core')

local stream = require('stream')

local TestSuite = require('./test_suite')


local TestSuites = stream.Readable:extend()

function TestSuites:initialize()
  -- hwm is set to the maximum number that fits in signed 32-bit number.
  stream.Readable.initialize(self, {objectMode = true, highWaterMark = 0x800000})

  self.suites = {}
  self.read_called = false
end

function TestSuites:_read(n)
  self.read_called = true
  self:push(nil)
end

function TestSuites:get_or_create_suite(test_suite_name)
  if self.read_called then
    debug('warning: get_or_create_suite() called after _read() is called.')
  end

  if self.suites[test_suite_name] == nil then
    local suite = TestSuite:new(test_suite_name)
    self:push(suite)
    self.suites[test_suite_name] = suite
  end
  return self.suites[test_suite_name]
end

return TestSuites
