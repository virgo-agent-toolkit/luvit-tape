luvit-tape
==========

TAP-producing test tool for Luvit

Example
-------
```lua
local test = require('..')("name of test suite")

test("My awesome test", nil, function(t)
  t:is_nil(nil, "nil should be nil")
  t:not_nil({}, "{} should not be nil")
  t:is_number(1, "1 should be a number")
  t:is_string("hello", "hello should be a string")
  t:is_table({}, "{} should not be a table")
  t:is_boolean(true, "true should b3 a boolean")
  t:is_array({1, 2, 3}, "{1, 2, 3} should be an array")
  t:equal({a = {1,2,3}, b = true, c = 'haha'}, {a = {1,2,3}, b = true, c = 'haha'}, "two tables should be same")
  t:finish()
end)

test("My super skipped test", nil, function(t)
  if true ~= false then
    t:skip("true is not equal to false!")
  end

  t:equal(1 + 1, 3)
  t:finish()
end)

test("My super awesome test", nil, function(t)
  t:is_number(42, "42 should be a number")
  t:equal({a = {1,2,3, 4}, b = true, c = 'haha'}, {a = {1,2,3}, b = true, c = 'haha'}, "are the two tables same?")
  t:finish()
end)

test("test case suffering from procrastination", nil, function(t)
  t:todo("goto a parallel universe")
end)
```
