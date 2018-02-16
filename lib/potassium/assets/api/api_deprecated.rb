module ApiDeprecated
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :deprecated_actions

    def deprecate(*actions)
      self.deprecated_actions ||= {}
      self.deprecated_actions[to_s] = actions
    end
  end

  included do
    after_action :deprecate_actions
  end

  private

  def deprecate_actions
    return unless self.class.deprecated_actions
    deprecated_actions = self.class.deprecated_actions[self.class.to_s]
    response.headers["Deprecated"] = true if deprecated_actions.include?(params[:action].to_sym)
  end
end
