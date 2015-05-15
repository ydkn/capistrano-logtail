module Capistrano
  module Logtail
    # Utility stuff to avoid cluttering of logtail.cap
    class Utility
      def initialize(context)
        @context = context
      end

      # Tail log file(s)
      def tail(*files)
        @context.info("Tailing #{files.join(' ')}")

        cmd = [
            :tail,
            '-F',
            "-n#{lines}",
            *files
          ].join(' ')

        @context.send(:with_ssh) do |ssh|
          ssh.open_channel do |chan|
            chan.exec(cmd) do |ch, success|
              chan.on_data do |ch, data|
                print data
              end
            end
            chan.wait
          end
          ssh.loop
        end
      end

      # Rails environment
      #
      # @return [String] the rails environment.
      def rails_env
        fetch(:rails_env, fetch(:stage, 'production')).to_s
      end

      # Number of log lines
      #
      # @return [Integer] number of existing log lines to show.
      def lines
        (ENV['n'] || fetch(:logtail_lines, 10)).to_i
      end
    end
  end
end
