class Recipes::Bullet < Rails::AppBuilder
  def create
    gather_gem 'bullet'
    recipe = self
    after(:gem_install) do
      recipe.bullet_config
    end
  end

  def installed?
    gem_exists?(/bullet/)
  end

  def install
    create
  end

  def bullet_config
    application bullet_after_initialize, env: "development"
    insert_into_file "app/jobs/application_job.rb", bullet_application_job_config, before: "end"
  end

  private

  def bullet_after_initialize
    <<~RUBY
      config.after_initialize do
        Bullet.enable = true
        Bullet.alert = true
        Bullet.bullet_logger = true
        Bullet.console = true
        Bullet.rails_logger = true
        Bullet.add_footer = true
      end
    RUBY
  end

  def bullet_application_job_config
    "  include Bullet::ActiveJob if Rails.env.development?\n"
  end
end
