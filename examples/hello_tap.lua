local test1 = require('..')("test_1")
local test2 = require('..')("test_2")

test1("My awesome test", nil, function(t)
  t:is_number(1, "1 should be a number")
  t:is_number(2, "2 should be a number")
  t.finish()
end)

test1("My super awesome test", nil, function(t)
  t:is_number(42, "42 should be a number")
  t:is_number({}, "is {} a number?")
  t.finish()
end)

test2("My super awesome test in test 2", nil, function(t)
  t:is_number(42, "42 should be a number")
  t:is_number({}, "is {} a number?")
  t.finish()
end)
