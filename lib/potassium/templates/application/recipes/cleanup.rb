erase_comments "config/application.rb"
erase_comments "config/environments/production.rb"
erase_comments "config/environments/staging.rb"
erase_comments "config/environments/test.rb"
erase_comments "config/environments/development.rb"
cut_comments "config/initializers/backtrace_silencers.rb", limit: 100
