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

        cmd = "tail -f #{files.join(' ')}"

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
    end
  end
end
