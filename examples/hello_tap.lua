local test = require('..')("test_tap")

test("My awesome test", function(t)
  t:is_number(1, "1 should be a number")
  t:is_number(2, "2 should be a number")
  t.finish()
end)

test("My super awesome test", function(t)
  t:is_number(42, "42 should be a number")
  t:is_number({}, "is {} a number?")
  t.finish()
end)
