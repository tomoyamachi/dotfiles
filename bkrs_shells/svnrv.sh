test=`svn st | grep M | sed -e s/"^M[ ]*"//`
svn revert $test
