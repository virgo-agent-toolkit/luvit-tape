local stream = require('../lib/modules/stream')
local json = require('json')

local DumpingWriter = stream.Writable:extend()

function DumpingWriter:initialize()
  stream.Writable.initialize(self, {objectMode = true})
end

function DumpingWriter:_write(data, encoding, callback)
  print(json.stringify(data))
  callback()
end

local exports = {}

exports.DumpingWriter = DumpingWriter

return exports
