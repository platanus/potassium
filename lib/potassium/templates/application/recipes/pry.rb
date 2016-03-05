class Recipes::Pry < Recipes::Base
  def create
    t.gather_gems(:development, :test) do
      gather_gem('pry-rails')
      gather_gem('pry-byebug')
    end

    t.template 'assets/.pryrc', '.pryrc'
  end
end
