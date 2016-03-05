class Recipes::Staging < Recipes::Base
  def create
    t.copy_file "assets/config/environments/staging.rb", "config/environments/staging.rb"
  end
end
