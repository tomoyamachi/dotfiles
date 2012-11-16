svn st | grep ? | sed -e s/"^?[ ]*"// | xargs svn add
