class Recipes::Cleanup < Recipes::Base
  def create
    t.erase_comments "config/application.rb"
    t.erase_comments "config/environments/production.rb"
    t.erase_comments "config/environments/staging.rb"
    t.erase_comments "config/environments/test.rb"
    t.erase_comments "config/environments/development.rb"
    t.cut_comments "config/initializers/backtrace_silencers.rb", limit: 100
  end
end
