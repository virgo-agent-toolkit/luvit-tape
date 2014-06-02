local core = require('core')
local stream = require('stream')

local Test = require('./test').Test

local TapTransform = stream.Transform:extend()

function TapTransform:initialize()
  stream.Transform.initialize(self, {objectMode = true})

  self.versionPrinted = false
end

function TapTransform:_transform(data, encoding, callback)

  if data == nil then
    callback(nil, nil)
  end

  if not core.instanceof(data, Test) then
    error('invalid data; should be a Test instance')
  end

  local tap = ""

  if not self.versionPrinted then
    self.versionPrinted = true
    tap = tap .. 'TAP version 13\n'
  end

  if data.ok then
    tap = tap .. 'ok ' .. tostring(data.id) .. ' ' .. data.name .. '\n'
  else
    tap = tap .. 'not ok ' .. tostring(data.id) .. ' ' .. data.name .. '\n'
  end

  -- TODO: yaml encoding details

  callback(nil, tap)
end

local exports = {}

exports.TapTransform = TapTransform

return exports
