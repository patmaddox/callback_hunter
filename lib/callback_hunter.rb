module CallbackHunter
  module ClassMethods
    def record_callbacks(&block)
      CallbackHunter.start_recording
      result = block.call
      CallbackHunter.stop_recording
      result
    end
  end

  def self.recording?
    @recording
  end

  def self.start_recording
    @recording = true
    @callbacks = []
  end

  def self.stop_recording
    @recording = false
  end

  def self.callbacks
    @callbacks
  end

  def self.record(callback)
    @callbacks << callback
  end
end

ActiveRecord::Base.extend CallbackHunter::ClassMethods

module ActiveSupport
  module Callbacks
    class Callback
      attr_reader :target, :benchmark, :result

      def call_with_callback_hunter(*args, &block)
        if should_run_callback?(*args) && CallbackHunter.recording?
          @target = args.first
          CallbackHunter.record(self)
        end
        @benchmark = Benchmark.measure { @result = call_without_callback_hunter(*args, &block) }
        @result
      end
      alias_method_chain :call, :callback_hunter
    end
  end
end

#module ActiveRecord
#  class Base
#    def create_or_update_with_callback_hunter
#      puts "oh hai there!"
#      create_or_update_without_callback_hunter
#    end
#    alias_method_chain :create_or_update, :callback_hunter
#  end
#end
