local exports = {}

for k,v in pairs(require('./lib/test')) do
  exports[k] = v
end

for k,v in pairs(require('./lib/test_result')) do
  exports[k] = v
end

for k,v in pairs(require('./lib/test_runner')) do
  exports[k] = v
end

for k,v in pairs(require('./lib/tap_transform')) do
  exports[k] = v
end

return exports
