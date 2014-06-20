local test = require('../')('test tape')

local Test = require('../lib/test')

test('test:is_nil()', nil, function(t)
  local test = Test:new('tmp', nil, function(t)
    t:is_nil(nil, '')
    t:finish()
  end)
  test._finish = function()
    t:equal(true, test.ok, "t:is_nil(nil) should not fail")

    test = Test:new('tmp', nil, function(t)
      t:is_nil({}, '')
      t:finish()
    end)
    test._finish = function()
      t:equal(false, test.ok, "t:is_nil({}) should fail")
    end
    test:run()
  end
  test:run()

  t:finish()
end)

test('test:not_nil()', nil, function(t)
  local test = Test:new('tmp', nil, function(t)
    t:not_nil(nil, '')
    t:finish()
  end)
  test._finish = function()
    t:equal(false, test.ok, "t:not_nil(nil) should fail")

    test = Test:new('tmp', nil, function(t)
      t:not_nil({}, '')
      t:finish()
    end)
    test._finish = function()
      t:equal(true, test.ok, "t:not_nil({}) should not fail")
    end
    test:run()
  end
  test:run()

  t:finish()
end)

test('test:is_function()', nil, function(t)
  local test = Test:new('tmp', nil, function(t)
    t:is_function(function() end, '')
    t:finish()
  end)
  test._finish = function()
    t:equal(true, test.ok, "t:is_function(function() end) should not fail")

    test = Test:new('tmp', nil, function(t)
      t:is_function({}, '')
      t:finish()
    end)
    test._finish = function()
      t:equal(false, test.ok, "t:is_function({}) should fail")
    end
    test:run()
  end
  test:run()

  t:finish()
end)

test('test:is_number()', nil, function(t)
  local test = Test:new('tmp', nil, function(t)
    t:is_number(42, '')
    t:finish()
  end)
  test._finish = function()
    t:equal(true, test.ok, "t:is_number(42) should not fail")

    test = Test:new('tmp', nil, function(t)
      t:is_number('42', '')
      t:finish()
    end)
    test._finish = function()
      t:equal(false, test.ok, "t:is_number('42') should fail")
    end
    test:run()
  end
  test:run()

  t:finish()
end)

test('test:is_string()', nil, function(t)
  local test = Test:new('tmp', nil, function(t)
    t:is_string('hello', '')
    t:finish()
  end)
  test._finish = function()
    t:equal(true, test.ok, "t:is_string('hello') should not fail")

    test = Test:new('tmp', nil, function(t)
      t:is_string(nil, '')
      t:finish()
    end)
    test._finish = function()
      t:equal(false, test.ok, "t:is_string(nil) should fail")
    end
    test:run()
  end
  test:run()

  t:finish()
end)

test('test:is_boolean()', nil, function(t)
  local test = Test:new('tmp', nil, function(t)
    t:is_boolean(false, '')
    t:finish()
  end)
  test._finish = function()
    t:equal(true, test.ok, "t:is_boolean(false) should not fail")

    test = Test:new('tmp', nil, function(t)
      t:is_boolean('true', '')
      t:finish()
    end)
    test._finish = function()
      t:equal(false, test.ok, "t:is_boolean('true') should fail")
    end
    test:run()
  end
  test:run()

  t:finish()
end)

test('test:is_table()', nil, function(t)
  local test = Test:new('tmp', nil, function(t)
    t:is_table({}, '')
    t:finish()
  end)
  test._finish = function()
    t:equal(true, test.ok, "t:is_table({}) should not fail")

    test = Test:new('tmp', nil, function(t)
      t:is_table('', '')
      t:finish()
    end)
    test._finish = function()
      t:equal(false, test.ok, "t:is_table('') should fail")
    end
    test:run()
  end
  test:run()

  t:finish()
end)

test('test:is_array()', nil, function(t)
  local test = Test:new('tmp', nil, function(t)
    t:is_array({[1] = 1, [2] = 2}, '')
    t:finish()
  end)
  test._finish = function()
    t:equal(true, test.ok, "t:is_array({[1] = 1, [2] = 2}) should not fail")

    test = Test:new('tmp', nil, function(t)
      t:is_array({[0] = 0, [1] = 1, [2] = 2}, '')
      t:finish()
    end)
    test._finish = function()
      t:equal(false, test.ok, "t:is_array('{[0] = 0, [1] = 1, [2] = 2}') should fail")
    end
    test:run()
  end
  test:run()

  t:finish()
end)
