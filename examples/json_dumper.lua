local core = require('core')
local json = require('json')

local stream = require('../modules/stream')
local Test = require('../lib/test').Test

local JSONDumper = stream.Transform:extend()

function JSONDumper:initialize()
  stream.Transform.initialize(self, {objectMode = true})
end

function JSONDumper:_transform(data, encoding, callback)
  if not data then
    callback()
    return
  end

  if not core.instanceof(data, Test) then
    error('invalide data; should be a Test instance')
  end

  local toDump = {}
  for k,v in pairs(data) do
    if type(v) ~= 'function' then
      toDump[k] = v
    end
  end
  callback(nil, json.stringify(toDump) .. '\n')
end

local exports = {}

exports.JSONDumper = JSONDumper

return exports
