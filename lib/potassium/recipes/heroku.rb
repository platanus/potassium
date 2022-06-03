class Recipes::Heroku < Rails::AppBuilder
  NAME_PREFIX = 'pl'
  ENVIRONMENTS = ['staging', 'production']
  HEROKU_NAMES_MAX_CHARS = 30

  def ask
    heroku = answer(:heroku) do
      Ask.confirm("Are you going to deploy to heroku? (#{who_am_i})")
    end

    if heroku
      set(:heroku, heroku)

      ENVIRONMENTS.each { |environment| set_app_name_for(environment) }
      set(:heroku_pipeline_name, heroku_pipeline_name)
    end
  end

  def create
    add_heroku if get(:heroku)
  end

  def install
    add_heroku
  end

  def installed?
    gem_exists?(/heroku-stage/)
  end

  private

  def add_heroku
    gather_gems(:production) do
      gather_gem('heroku-stage')
    end

    copy_file '../assets/Procfile', 'Procfile'
    copy_file '../assets/.buildpacks', '.buildpacks'
    copy_file '../assets/bin/release', 'bin/release'
    run 'chmod a+x bin/release'

    template "../assets/bin/setup_heroku.erb", "bin/setup_heroku", force: true
    run "chmod a+x bin/setup_heroku"

    # logged_in? ? create_apps : puts_not_logged_in_msg

    add_readme_header :deployment
  end

  def create_apps
    ENVIRONMENTS.each { |environment| create_app_on_heroku(environment) }
    puts "Remember to connect the github repository to the new pipeline"
    open_pipeline_command = "\e[33mheroku pipelines:open #{heroku_pipeline_name}\e[0m"
    puts "run #{open_pipeline_command} to open the dashboard"
  end

  def puts_not_logged_in_msg
    puts "You are not logged in into heroku"
    login_command = "\e[33mheroku login\e[0m"
    puts "Run #{login_command} and enter your credentials"
    puts "You can install the heroku recipe again to create the app in heroku"
    install_command = "\e[33mpostassium install heroku --force\e[0m"
    puts "Just run #{install_command}"
  end

  def heroku_pipeline_name
    @heroku_pipeline_name ||= valid_heroku_name(app_name.dasherize, 'pipeline', false)
  end

  def set_app_name_for(environment)
    default_name = "#{NAME_PREFIX}-#{app_name.dasherize}-#{environment}"
    set("heroku_app_name_#{environment}".to_sym, valid_heroku_name(default_name, environment))
  end

  def logged_in?
    !who_am_i.include? "not logged in"
  end

  def who_am_i
    `heroku auth:whoami`.strip
  end

  def create_app_on_heroku(environment)
    rack_env = "RACK_ENV=production"
    staged_app_name = get("heroku_app_name_#{environment}".to_sym)

    run_toolbelt_command "create #{staged_app_name} --remote #{environment}"
    run_toolbelt_command "labs:enable runtime-dyno-metadata", staged_app_name
    run_toolbelt_command "config:add HEROKU_APP_NAME=#{staged_app_name}", staged_app_name
    run_toolbelt_command "config:add #{rack_env}", staged_app_name

    set_rails_secrets(environment)
    set_app_multi_buildpack(environment)
    add_app_to_pipeline(staged_app_name, environment)
  end

  def set_rails_secrets(environment)
    run_toolbelt_command(
      "config:add SECRET_KEY_BASE=#{generate_secret}",
      get("heroku_app_name_#{environment}".to_sym)
    )
  end

  def set_app_multi_buildpack(environment)
    run_toolbelt_command(
      "buildpacks:set https://github.com/heroku/heroku-buildpack-multi.git",
      get("heroku_app_name_#{environment}".to_sym)
    )
  end

  def add_app_to_pipeline(app_env_name, environment)
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

  def run_toolbelt_command(command, app_env_name = nil)
    if app_env_name.nil?
      `heroku #{command}`
    else
      `heroku #{command} --app #{app_env_name}`
    end
  end

  def valid_heroku_name(name, element, force_suffix = true)
    suffix = "-#{element}"
    while name.length > HEROKU_NAMES_MAX_CHARS
      puts "Heroku names must be shorter than #{HEROKU_NAMES_MAX_CHARS} chars."
      if force_suffix
        puts "Potassium uses the heroku-stage gem, because of that '#{suffix}' will be "\
             "added to your app name. The suffix, #{suffix}, counts towards the app name length."
      end
      name = Ask.input("Please enter a valid name for #{element}:")
      name += suffix if force_suffix && !name.end_with?(suffix)
    end
    name
  end
end
