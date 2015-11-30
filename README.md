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

if ParallelTests.is_running?
  ParallelTests.after_tests { puts 'all done!' }
end
```
