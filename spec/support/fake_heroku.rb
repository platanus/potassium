require 'active_support/all'

class FakeHeroku
  RECORDER = File.expand_path(File.join('..', '..', 'tmp', 'heroku_commands'),
                              File.dirname(__FILE__))

  def initialize(args)
    @args = args
  end

  def run!
    case @args.first
    when "pipelines:info"
      if FakeHeroku.has_created_pipeline?
        puts "=== dummy-app\nstaging:\tpl-dummy-app-staging\nproduction:\tpl-dummy-app-production"
      end
    when "auth:whoami"
      puts "foo@bar.com"
    end
    File.open(RECORDER, 'a') do |file|
      file.puts @args.join(' ')
    end
  end

  def self.clear!
    FileUtils.rm_rf RECORDER
  end

  def self.has_gem_included?(project_path, gem_name)
    gemfile = File.open(File.join(project_path, 'Gemfile'), 'a')

    File.foreach(gemfile).any? do |line|
      line.match(/#{Regexp.quote(gem_name)}/)
    end
  end

  def self.has_created_app_for?(environment, flags = nil)
    staged_app_name = "pl-#{PotassiumTestHelpers::APP_NAME.dasherize}-#{environment}"

    command = if flags
                "create #{staged_app_name} #{flags} --remote #{environment}\n"
              else
                "create #{staged_app_name} --remote #{environment}\n"
              end

    File.foreach(RECORDER).any? { |line| line == command }
  end

  def self.has_configured_vars?(environment, var)
    app_name = PotassiumTestHelpers::APP_NAME.dasherize
    staged_app_name = "pl-#{app_name}-#{environment}"
    commands_ran =~ /^config:add.*#{var}=.+ --app #{staged_app_name}\n/
  end

  def self.has_created_pipeline_for?(environment)
    has_done_pipeline_for?(environment, 'create')
  end

  def self.has_add_pipeline_for?(environment)
    has_done_pipeline_for?(environment, 'add')
  end

  def self.has_created_pipeline?
    commands_ran =~ /^pipelines:create/
  end

  def self.has_done_pipeline_for?(environment, command)
    app_name = PotassiumTestHelpers::APP_NAME.dasherize
    staged_app_name = "pl-#{app_name}-#{environment}"
    commands_ran =~ /^pipelines:#{command} #{app_name} --stage #{environment} |
                     --app #{staged_app_name}/
  end

  def self.commands_ran
    @commands_ran ||= File.read(RECORDER)
  end
end
