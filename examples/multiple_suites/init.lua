require('./test1')
require('./test1_')
require('./test2')
require('./test3')

for i=1,256 do
  require('./testx')(i)
end
