class Recipes::I18n < Recipes::Base
  def ask
    languages = {
      es: "Spanish",
      en: "English"
    }

    lang = t.answer(:lang) do
      languages.keys[Ask.list("What is the main language of your app?", languages.values)]
    end

    t.set(:lang, lang)
  end

  def create
    t.gather_gem('rails-i18n')

    if t.equals?(:lang, :es)
      t.template('assets/es.yml', 'config/locales/es.yml')
    end

    t.gsub_file 'config/application.rb', /# config\.i18n\.default_locale =[^\n]+\n/ do
      "config.i18n.default_locale = :#{t.get(:lang)}\n"
    end
  end
end
