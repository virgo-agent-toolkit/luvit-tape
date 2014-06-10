local test = require('../..')("test_1")

test("My alternate awesome test", nil, function(t)
  t:is_number(42, "42 should be a number")
  t:finish()
end)
