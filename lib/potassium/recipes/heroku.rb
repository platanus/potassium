class Recipes::Heroku < Recipes::Base
  def ask
    heroku = t.answer(:heroku) { Ask.confirm("Are you going to deploy to heroku?") }
    t.set(:heroku, heroku) if heroku
  end

  def create
    add_heroku if t.get(:heroku)
  end

  def install
    add_heroku
  end

  private

  def add_heroku
    t.gather_gems(:production, :staging) do
      gather_gem('rails_stdout_logging')
    end

    t.copy_file '../assets/Procfile', 'Procfile'
    t.copy_file '../assets/.buildpacks', '.buildpacks'
  end
end
