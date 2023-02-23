module Dotenv
  module Substitutions
    module Command
      class << self
        INTERPOLATED_SHELL_COMMAND = /
          (?<backslash>\\)?   # is it escaped with a backslash?
          COMMAND_EXPAND                  # literal $
          (?<cmd>             # collect command content for eval
            \(                # require opening paren
            (?:[^()]|\g<cmd>)+  # allow any number of non-parens, or balanced
                              # parens (by nesting the <cmd> expression
                              # recursively)
            \)                # require closing paren
          )
        /x
      end
    end
  end
end
