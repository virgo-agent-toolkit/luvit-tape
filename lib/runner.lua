local core = require('core')

local Transform = require('../modules/stream').Transform

local Runner = Transform:extend()

function Runner:initialize()
  Transform.initialize(self, {objectMode = true})
end

function Runner:_transform(t, encoding, callback)
  if t then
    if not t.run or type(t.run) ~= 'function' then
      error('invalid data; expecting a .run() method')
    end
    t._finish = function()
      self:push(t)
      callback()
    end
    t:run()
  else
    callback()
  end
end

return Runner
