require 'test_helper'

class ParallelTests::ExtensionsTest < Minitest::Spec
  describe '#after_tests_retry_failing_tests' do
    before do
      Dir.chdir File.expand_path(File.join __FILE__, '../../../dummy/')
    end

    describe 'a successful test' do
      it 'returns a zero exit code' do
        assert run_test('always_successful_test.rb') == true
      end
    end

    describe 'a test that fails the first time but not the second' do
      it 'returns a zero exit code' do
        FileUtils.rm 'touch.txt' rescue nil
        assert run_test('fails_every_other_time_test.rb') == true
      end
    end

    describe 'a test that always fails' do
      it 'returns a non-zero exit code' do
        assert run_test('always_failing_test.rb') != true
      end
    end
  end

  def run_test(test_file)
    cmd = "bundle exec parallel_test #{test_file}"
    Bundler.with_clean_env { system "#{cmd} > /dev/null" }
  end
end
