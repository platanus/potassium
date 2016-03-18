class Recipes::I18n < Rails::AppBuilder
  def ask
    languages = {
      es: "Spanish",
      en: "English"
    }

    lang = answer(:lang) do
      languages.keys[Ask.list("What is the main language of your app?", languages.values)]
    end

    set(:lang, lang)
  end

  def create
    gather_gem('rails-i18n')

    if equals?(:lang, :es)
      template('../assets/es.yml', 'config/locales/es.yml')
    end

    gsub_file 'config/application.rb', /# config\.i18n\.default_locale =[^\n]+\n/ do
      "config.i18n.default_locale = :#{get(:lang)}\n"
    end
  end
end
