# frozen_string_literal: true

# Command Interface
class Command
  def execute
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
