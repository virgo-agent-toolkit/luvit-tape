return function(id)
  local test = require('../..')('test_suite_x_' .. tostring(id))

  test("haha " .. tostring(id), nil, function(t)
    t:is_number(42, "42 should be a number")
    t:finish()
  end)
end
