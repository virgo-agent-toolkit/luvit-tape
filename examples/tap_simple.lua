local test = require('..')("test_1")

test("My awesome test", nil, function(t)
  t:is_number(1, "1 should be a number")
  t:is_number(2, "2 should be a number")
  t:finish()
end)

test("My super skipped test", nil, function(t)
  if true ~= false then
    t:skip("true is not equal to false!")
  end

  t:equal(1 + 1, 3)
end)

test("My super awesome test", nil, function(t)
  t:is_number(42, "42 should be a number")
  t:is_number({}, "is {} a number?")
  t:finish()
end)

test("test case suffering from procrastination", nil, function(t)
  t:todo("goto a parallel universe")
end)
