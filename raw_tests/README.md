# Raw Tests

Raw Tests is a simple project to demonstrate writing some basic tests for a bit of Ruby code using only standard library tools. `filter.rb` holds the class under test and `filter_test.rb` has the unit tests.

### IRB
To work with a the code under test in irb, simply call `load "filter.rb"` inside an irb console session. This can be called again after changing the code, and it will reload the file from scratch.

To require all the files in the present directory except the tests, you can use a bit of code like:
```ruby
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file).include?("test")
end
```

You can use the inverse of that filter expression to load _only_ the tests.

### Test::Unit
`filter_test.rb` includes some comments in the setup and teardown methods not used in this case so that the order they are run is clear. More documentation here: https://www.rubydoc.info/gems/test-unit/2.5.2/Test/Unit
