class Recipes::Env < Recipes::Base
  def create
    t.gather_gems(:development, :test) do
      gather_gem('dotenv-rails')
    end

    t.template 'assets/.env.example.erb', '.env.example'
    t.run "cp .env.example .env"
  end
end
