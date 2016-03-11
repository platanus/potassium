class Recipes::Secrets < Recipes::Base
  def create
    t.template '../assets/config/secrets.yml.erb', 'config/secrets.yml', force: true
  end
end
