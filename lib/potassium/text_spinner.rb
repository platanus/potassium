module Potassium
  # TODO: I don't know if this is a concern of this gem. Maybe we should move this later
  class TextSpinner
    attr_accessor :wait_condition, :base_message, :interval, :message_continuations,
      :counter, :started

    DEFAULT_ATTRIBUTES = {
      wait_condition: -> { },
      base_message: "",
      interval: 0.4,
      message_continuations: ["", ".", "..", "..."]
    }

    def initialize(attributes = {})
      DEFAULT_ATTRIBUTES.merge(attributes).each do |key, value|
        self.public_send("#{key}=", value)
      end
      self.started = false
      self.counter = 0
    end

    def start
      fail already_started_message if started
      self.started = true

      Thread.new do
        loop do
          break if wait_condition.call(counter)
          print_message
          sleep interval
          self.counter += 1
        end
        clear_message
        self.started = false
      end
    end

    private

    def print_message
      message_continuation = message_continuations[counter] || begin
        message_continuations[counter % message_continuations.size]
      end
      print "\r#{base_message}#{message_continuation}"
    end

    def clear_message
      print "\r#{" " * (base_message.size * 2)}\r"
    end

    def already_started_message
      "Please don't start this text spinner while is running. It can cause race conditions."
    end
  end
end
