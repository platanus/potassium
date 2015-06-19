module TemplateDSL
  def self.extend_dsl(object, source_path: __FILE__)
    require_relative './template-helpers'
    require_relative './variable-helpers'
    require_relative './environment-helpers'
    require_relative './gem-helpers'
    require_relative './callback-helpers'
    require_relative './recipe-helpers'

    object.send :extend, RecipeHelpers
    object.send :extend, TemplateHelpers
    object.send :extend, VariableHelpers
    object.send :extend, EnvironmentHelpers
    object.send :extend, GemHelpers
    object.send :extend, CallbackHelpers

    object.send :source_path, source_path
  end
end
