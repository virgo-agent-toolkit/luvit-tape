local core = require('core')

local Transform = require('../modules/stream').Transform
local Test = require('./test').Test

local TestRunner = Transform:extend()

function TestRunner:initialize()
  Transform.initialize(self, {objectMode = true})
end

function TestRunner:_transform(t, encoding, callback)
  if t then
    if not core.instanceof(t, Test) then
      error('invalide data; should be a Test instance')
    end
    t.finish = function()
      callback(nil, t)
    end
    t.func(t)
  else
    callback()
  end
end

local exports = {}

exports.TestRunner = TestRunner

return exports
