class Recipes::Erd < Rails::AppBuilder
  FILES = ['.erdconfig', 'docs/.keep', 'lib/tasks/auto_generate_erd_diagram.rake']

  def ask
    erd = answer(:erd) do
      Ask.confirm("Do you want to generate rails-erd diagram after each migration?")
    end

    if erd
      set(:erd, rails_erd)
    end
  end

  def create
    return unless get(:erd)
    
    gather_gems(:development) do
      gather_gem('rails-erd')
    end

    FILES.each do ¡file¡
      template("../assets/#{file}", file)
    end
  end

  def install
    create
  end

  def installed?
    gem_exists?(/rails-erd/) && 
  end

  private

  def erd_files_present?
    FILES.reduce(true) { |acc, file| acc  && file_exist?(file) }
  end
end
