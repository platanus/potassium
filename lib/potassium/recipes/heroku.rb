class Recipes::Heroku < Rails::AppBuilder
  NAME_PREFIX = 'pl'

  attr_accessor :app_name_staging

  def initialize(args)
    super(args)
    set(:heroku_app_name_staging, app_name_for('staging'))
    set(:heroku_app_name_production, app_name_for('production'))
  end

  def ask
    heroku = answer(:heroku) do
      Ask.confirm("Are you going to deploy to heroku? (#{who_am_i})")
    end

    if heroku
      set(:heroku, heroku)
    end
  end

  def create
    add_heroku if get(:heroku)
  end

  def install
    if gem_exists?(/rails_stdout_logging/) && !force?
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

    if logged_in?
      %w(staging production).each do |environment|
        create_app_on_heroku(environment)
      end
      outro
    else
      puts "You are not logged in into heroku"
      login_command = "\e[33mheroku login\e[0m"
      puts "Run #{login_command} and enter your credentials"
      puts "You can install the heroku recipe again create the app in heroku"
      install_command = "\e[33mpostassium install heroku --force\e[0m"
      puts "Just run #{install_command}"
    end

    add_readme_header :deployment
  end

  def heroku_pipeline_name
    app_name.dasherize
  end

  def app_name_for(environment)
    "#{NAME_PREFIX}-#{app_name.dasherize}-#{environment}"
  end

  def logged_in?
    !who_am_i.include? "not logged in"
  end

  def who_am_i
    `heroku auth:whoami`.strip
  end

  def create_app_on_heroku(environment)
    rack_env = "RACK_ENV=#{environment} RAILS_ENV=#{environment}"
    staged_app_name = app_name_for(environment)

    run_toolbelt_command "create #{staged_app_name}", staged_app_name
    run_toolbelt_command "config:add #{rack_env}", staged_app_name

    set_rails_secrets(environment)
    add_app_to_pipeline(staged_app_name, environment)
  end

  def set_rails_secrets(environment)
    run_toolbelt_command(
      "config:add SECRET_KEY_BASE=#{generate_secret}",
      app_name_for(environment)
    )
  end

  def add_app_to_pipeline(app_env_name, environment)
    pipelines_plugin = `heroku plugins | grep pipelines`
    if pipelines_plugin.empty?
      puts "You need heroku pipelines plugin. Run: heroku plugins:install heroku-pipelines"
      exit 1
    end

    pipeline = `heroku pipelines:info \
      #{heroku_pipeline_name} 2>/dev/null | grep #{heroku_pipeline_name}`
    pipeline_command = pipeline.empty? ? "create" : "add"

    run_toolbelt_command(
      "pipelines:#{pipeline_command} #{heroku_pipeline_name} \
        --stage #{environment}",
      app_env_name
    )
  end

  def generate_secret
    SecureRandom.hex(64)
  end

  def run_toolbelt_command(command, app_env_name)
    `heroku #{command} --app #{app_env_name}`
  end

  def outro
    puts "Remember to connect the github repository to the new pipeline"
    open_pipeline_command = "\e[33mheroku pipelines:open #{heroku_pipeline_name}\e[0m"
    puts "run #{open_pipeline_command} to open the dashboard"
  end
end
