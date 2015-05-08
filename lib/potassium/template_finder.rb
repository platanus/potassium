module Potassium
  class TemplateFinder
    TEMPLATES = {
      default: Potassium::ApplicationGenerator
    }

    def default_template
      find(:default)
    end

    def find(name)
      TEMPLATES.fetch(name)
    end
  end
end
