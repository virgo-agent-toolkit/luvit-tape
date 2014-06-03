local core = require('core')
local Test = require('./test').Test
local stream = require('../modules/stream')
local table = require('table')

local TestSuite = stream.Readable:extend()

function TestSuite:initialize(suite_name)
  stream.Readable.initialize(self, {objectMode = true})

  self.suite_name = suite_name

  self.currentTestID = 1

  self.ready = {}
  self.done = {}

  self.streamRequested = false

  self.running = false
end

function TestSuite:_read(n)
  self.streamRequested = false
  for i = 1,n,1 do
    if table.getn(self.done) ~= 0 then
      self:push(table.remove(self.done, 1))
    else
      -- we don't have data yet but we'll push it out whenever next one is
      -- available.
      self.streamRequested = true
      break
    end
  end

  if table.getn(self.done) == 0 and table.getn(self.ready) == 0 then
    self:push(nil)
  end
end

function TestSuite:test(name, conf, cb)
  if running then
    error(':test() should be called only before :go()')
  end

  if type(conf) == 'function' then
    cb = conf
    conf = nil
  end
  if type(name) == 'object' then
    conf = name
    name = nil
  end
  if type(name) == 'function' then
    cb = name
    name = nil
  end

  if not conf then conf = {} end
  if not name then name = '' end

  table.insert(self.ready, function()
    local t = Test:new(name, conf)
    t.id = self.currentTestID
    self.currentTestID = self.currentTestID + 1
    t.finish = function()
      if self.streamRequested then
        -- a stream consumer asked for data. we push it out without adding it
        -- into done table
        self:push(t)
      else
        table.insert(self.done, t)
      end
      table.remove(self.ready, 1)
      if table.getn(self.ready) > 0 then
        process.nextTick(self.ready[1])
      else
        process.nextTick(self.finish_cb)
      end
    end
    cb(t)
  end)
end

function TestSuite:go(cb)
  if not running then
    self.finish_cb = cb
    if table.getn(self.ready) > 0 then
      process.nextTick(self.ready[1])
    end
  end
end

local exports = {}

exports.TestSuite = TestSuite

return exports
