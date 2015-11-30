require 'parallel_tests/extensions/version'

module ParallelTests
  module Extensions
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
