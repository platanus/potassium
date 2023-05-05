require "rubocop"

module RubocopHelpers
  def run_rubocop
    options, paths = RuboCop::Options.new.parse(["-A"])
    runner = RuboCop::Runner.new(options, RuboCop::ConfigStore.new)
    runner.run(paths)
  end
end
