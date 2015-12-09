require 'parallel_tests/extensions/version'
require 'active_support/core_ext/string/inflections'
require 'yaml'
require 'logger' # todo move to where used in m-r-ptr gem

module ParallelTests
  module Retries
    def retry_failed_tests(ignore: nil)
      # Hacky
      if defined?(Minitest)
        if first_process?
          report = Minitest::Reporters::ParallelTestsReporter.compile_reports! 
          failed = report.select {|r| r[:failures].any?}
          if failed.any?
            puts "\nThe following tests failed:"
            puts failed.map {|f| f[:location]}.join("\n")

            puts "\nRe-running failed tests"
            # TODO Doesn't work, this is a backtrace for where the exception occurred, what if we fail on setup?
            found_all_test_files_for_failures = true
            test_failures = failed.flat_map do |test| 
              guessed_test_name = test[:test_class_name].split('::').last
              test_files = Dir["**/#{guessed_test_name.underscore}.rb"].entries
              found_all_test_files_for_failures = false if test_files.empty?
              test_files
            end

            test_files.reject! {|f| f[ignore]} if ignore

            # hack
            ENV.delete 'TEST_ENV_NUMBER'

            # TODO fix and variablize
            cmd = %Q{ruby -Ilib:test -e "#{test_failures.uniq.map {|f| "load '#{f}';"}.join("\n")}"}
            puts cmd
            did_pass = system cmd

            if did_pass && found_all_test_files_for_failures
              puts 'All tests passed on retry, marking build as success'
              exit(0)
            else
              # use default messaging
            end

            # TODO parse output and print status
          end
        end
      end
    end
  end

  module Extensions
    include Retries

    # @example
    #   ParallelTests.is_running?
    # @return whether or not parallel test is running
    def is_running?
      ENV.has_key?('TEST_ENV_NUMBER')
    end

    def after_tests(&block)
      if is_running?
        @afters ||= []
        @afters << block
        install_after_hook unless @after_hook_installed
      end
    end

    private

    def install_after_hook
      @after_hook_installed = true
      if first_process?
        at_exit do
          wait_for_other_processes_to_finish
          @afters.each(&:call) 
        end
      end
    end
  end
end

if defined?(ParallelTests)
  ParallelTests.extend(ParallelTests::Extensions)
end
