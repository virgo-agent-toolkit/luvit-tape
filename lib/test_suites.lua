local table = require('table')
local core = require('core')

local stream = require('stream')

local TestSuite = require('./test_suite').TestSuite
local TapProducer = require('./tap_producer').TapProducer
local TestRunner = require('./test_runner').TestRunner


local TestSuites = stream.Readable:extend()

function TestSuites:initialize()
  stream.Readable.initialize(self, {objectMode = true, highWaterMark = 1024})

  self.test_suites = {} -- in case highWaterMark is hit
  self.read_called = false
end

function TestSuites:_read(n)
  self.read_called = true
  for i = 1,n do
    if table.getn(self.test_suites) ~= 0 then
      self:push(table.remove(self.test_suites, 1))
    else
      self:push(nil)
      break
    end
  end
end

function TestSuites:new_suite(test_suite_name)
  if self.read_called then
    debug('warning: test() called after _read() is called.')
  end

  local suite = TestSuite:new(test_suite_name)
  if not self:push(suite) then
    table.insert(self.test_suites, suite)
  end
  return suite
end


local TestSuitesRunner = stream.Writable:extend()

function TestSuitesRunner:initialize()
  stream.Writable.initialize(self, {objectMode = true})
end

function TestSuitesRunner:_write(data, encoding, callback)
  if data == nil then
    return
  end
  if not core.instanceof(data, TestSuite) then
    errors('only TestSuite instances should be written into TestSuitesRunner')
  end

  local producer = TapProducer:new()
  producer:once('end', function()
    callback()
  end)
  data:pipe(TestRunner:new()):pipe(producer):pipe(process.stdout)
end


local exports = {}

exports.TestSuites = TestSuites
exports.TestSuitesRunner = TestSuitesRunner

return exports
