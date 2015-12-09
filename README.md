# ParallelTests::Extensions

helper methods for working with [parallel_tests](https://github.com/grosser/parallel_tests)

## Installation

```rb
gem 'parallel_tests-extensions'
```

## Usage

```rb
require 'parallel_tests'
require 'parallel_tests/extensions'

# Do something after tests complete
if ParallelTests.is_running?
  ParallelTests.after_tests { puts 'all done!' }
end

# Minitest only: Re-run any failed tests to see if 
# errors are transient
if ParallelTests.is_running?
  ParallelTests.after_tests do
    ParallelTests.retry_failed_tests
  end

  # Used to by each test process to log results
  require 'minitest/reporters/parallel_tests_reporter'
  Minitest::Reporters.use!(Minitest::Reporters::ParallelTestsReporter.new)
end
```
