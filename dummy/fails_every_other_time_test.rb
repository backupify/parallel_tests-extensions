$: << '../lib'

require 'parallel_tests'
require 'parallel_tests/extensions'

ParallelTests.after_tests do
  ParallelTests.retry_failed_tests
end

require 'minitest/reporters/parallel_tests_reporter'

if ParallelTests.is_running?
  Minitest::Reporters.use!(Minitest::Reporters::ParallelTestsReporter.new)
end

require 'minitest/autorun'
require 'minitest/spec'

class FailsEveryOtherTimeTest < Minitest::Spec
  it 'always succeeds' do
    file = 'touch.txt'
    if File.exists?(file)
      FileUtils.rm(file)
      assert true
    else
      File.open(file, 'w') {|f| f.write ''}
      fail
    end
  end
end
