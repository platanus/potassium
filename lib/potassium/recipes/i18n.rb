class Recipes::I18n < Rails::AppBuilder
  def ask
    languages = {
      "es-CL": "es-CL (Chile)",
      en: "en (USA)"
    }

    lang = answer(:locale) do
      languages.keys[Ask.list("What is the main locale of your app?", languages.values)]
    end

    set(:lang, lang)
  end

  def create
    gather_gem('rails-i18n')

    if equals?(:lang, :"es-CL")
      template('../assets/es-CL.yml', 'config/locales/es-CL.yml')
    end

    gsub_file 'config/application.rb', /< Rails::Application/ do
      "< Rails::Application\n    config.i18n.default_locale = '#{get(:lang)}'\n    config.i18n.fallbacks = [:es, :en]\n"
    end
  end
end
