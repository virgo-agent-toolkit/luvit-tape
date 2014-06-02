local stream = require('../lib/modules/stream')
local json = require('json')

local DumpingWritter = stream.Writable:extend()

function DumpingWritter:initialize()
  stream.Writable.initialize(self, {objectMode = true})
end

function DumpingWritter:_write(data, encoding, callback)
  print(json.stringify(data))
  callback()
end

local exports = {}

exports.DumpingWritter = DumpingWritter

return exports
