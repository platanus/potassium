module RubocopHelpers
  def rubocop_revision
    fix_environments
  end

  private

  def fix_environments
    # Style problem in Rails 5 production environments
    file_name = "config/environments/production.rb"
    production = File.read(file_name)
    production.gsub!("config.log_tags = [ :request_id ]", "config.log_tags = [:request_id]")
    File.open(file_name, "w") { |file| file.write(production) }
  end
end
