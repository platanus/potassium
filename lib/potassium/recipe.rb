module Recipes
  class Base
    def initialize(template)
      self.t = template
    end

    private

    attr_accessor :t
  end
end
