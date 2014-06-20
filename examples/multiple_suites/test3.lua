local test = require('../..')("test_3")

test("My super third test", nil, function(t)
  t:is_number(42, "42 should be a number")
  t:is_number({}, "is {} a number?")
  t:finish()
end)
