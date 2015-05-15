gather_gem('rails-i18n')

if equals?(:lang, 'es')
  template 'assets/es.yml', 'config/locales/es.yml'
end

gsub_file 'config/application.rb', /# config\.i18n\.default_locale =[^\n]+\n/ do
  "config.i18n.default_locale = :#{get(:lang)}\n"
end
