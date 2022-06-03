module TemplateDSL
  def self.extend_dsl(object, source_path: __FILE__)
    require_relative './template-helpers'
    require_relative './variable-helpers'
    require_relative './environment-helpers'
    require_relative './gem-helpers'
    require_relative './docker-helpers'
    require_relative './callback-helpers'
    require_relative './answer-helpers'
    require_relative './info-helpers'
    require_relative './readme-helpers'
    require_relative './rubocop-helpers'
    require_relative './json-helpers'

    object.send :extend, TemplateHelpers
    object.send :extend, VariableHelpers
    object.send :extend, EnvironmentHelpers
    object.send :extend, GemHelpers
    object.send :extend, CallbackHelpers
    object.send :extend, AnswerHelpers
    object.send :extend, InfoHelpers
    object.send :extend, ReadmeHelpers
    object.send :extend, RubocopHelpers
    object.send :extend, JsonHelpers

    object.send :source_path, source_path
    object.load_answers
  end
end
