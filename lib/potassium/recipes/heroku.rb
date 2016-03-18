class Recipes::Heroku < Rails::AppBuilder
  def ask
    heroku = answer(:heroku) { Ask.confirm("Are you going to deploy to heroku?") }
    set(:heroku, heroku) if heroku
  end

  def create
    add_heroku if get(:heroku)
  end

  def install
    if gem_exists?(/rails_stdout_logging/)
      info "Heroku is already installed"
    else
      add_heroku
    end
  end

  private

  def add_heroku
    gather_gems(:production, :staging) do
      gather_gem('rails_stdout_logging')
    end

    copy_file '../assets/Procfile', 'Procfile'
    copy_file '../assets/.buildpacks', '.buildpacks'
  end
end
