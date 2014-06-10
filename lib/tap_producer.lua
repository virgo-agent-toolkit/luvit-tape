local core = require('core')
local stream = require('../modules/stream')

local Test = require('./test').Test

local TapProducer = stream.Transform:extend()

function TapProducer:initialize()
  stream.Transform.initialize(self, {objectMode = true})

  self.versionPrinted = false
end

function TapProducer:_transform(data, encoding, callback)

  if data == nil then
    callback()
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
    tap = tap .. 'ok '
  else
    tap = tap .. 'not ok '
  end

  tap = tap .. tostring(data.id) .. ' ' .. data.name

  if data.directives['skip'].skipped then
    tap = tap .. ' # skip ' .. data.directives['skip'].reason
  end

  if data.directives['todo'].is_todo then
    tap = tap .. ' # TODO ' .. data.directives['todo'].explanation
  end

  tap = tap .. '\n'

  -- TODO: yaml encoding details

  callback(nil, tap)
end

local exports = {}

exports.TapProducer = TapProducer

return exports
