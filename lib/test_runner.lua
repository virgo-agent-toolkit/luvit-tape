local Transform = require('../modules/stream').Transform

local TestRunner = Transform:extend()

function TestRunner:initialize()
  Transform.initialize(self, {objectMode = true})
end

function TestRunner:_transform(t, encoding, callback)
  if t then
    t.finish = function()
      callback(nil, t)
    end
    t.func(t)
  else
    callback(nil, nil)
  end
end

local exports = {}

exports.TestRunner = TestRunner

return exports
