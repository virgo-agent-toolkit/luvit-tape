local core = require('core')
local stream = require('../modules/stream')
local table = require('table')

local Test = require('./test')
local Runner = require('./runner')
local TapProducer = require('./tap_producer')

local TestSuite = stream.Readable:extend()

function TestSuite:initialize(suite_name)
  -- hwm is set to the maximum number that fits in signed 32-bit number.
  stream.Readable.initialize(self, {objectMode = true, highWaterMark = 0x800000})
  self.suite_name = suite_name
  self.currentTestID = 1
  self.read_called = false
end

function TestSuite:_read(n)
  self.read_called = true
  self:push(nil)
end

function TestSuite:test(name, conf, func)
  if self.read_called then
    debug('warning: test() called after _read() is called.')
  end

  if not conf then conf = {} end
  if not name then name = '' end

  local t = Test:new(name, conf, func)
  t.id = self.currentTestID
  self.currentTestID = self.currentTestID + 1
  self:push(t)
end

function TestSuite:run()
  local producer = TapProducer:new()
  producer:once('end', self._finish)
  self:pipe(Runner:new()):pipe(producer):pipe(process.stdout)
end

return TestSuite
