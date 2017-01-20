module PotassiumTestHelpers
  APP_NAME = "dummy_app"

  def remove_project_directory
    FileUtils.rm_rf(project_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def create_dummy_project(arguments = {})
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        add_fakes_to_path
        full_arguments = hash_to_arguments(default_arguments.merge(arguments))
        run_command("#{potassium_bin} create #{APP_NAME} #{full_arguments}")
        on_project { run_command("hound rules update ruby --local") }
      end
    end
  end

  def drop_dummy_database
    return unless File.exist?(project_path)
    on_project { run_command("bundle exec rake db:drop") }
  end

  def add_fakes_to_path
    ENV["PATH"] = "#{support_bin}:#{ENV['PATH']}"
  end

  def project_path
    @project_path ||= Pathname.new("#{tmp_path}/#{APP_NAME}")
  end

  def on_project(&block)
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        block.call
      end
    end
  end

  private

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def potassium_bin
    File.join(root_path, "bin", "potassium")
  end

  def default_arguments
    {
      "db" => "postgresql",
      "lang" => "es",
      "heroku" => false,
      "admin" => false,
      "pundit" => false,
      "paperclip" => false,
      "email_service" => "aws_ses",
      "devise" => false,
      "api" => false,
      "delayed-job" => false,
      "github" => false,
      "github-private" => false,
      "clockwork" => false,
      "sentry" => false
    }
  end

  def hash_to_arguments(hash)
    hash.map do |key, value|
      if value == true
        "--#{key}"
      elsif value == false
        "--no-#{key}"
      elsif value
        "--#{key}=#{value}"
      end
    end.join(" ")
  end

  def support_bin
    File.join(root_path, "spec", "fakes", "bin")
  end

  def root_path
    File.expand_path("../../../", __FILE__)
  end

  def run_command(command)
    system(command)
  end

  def run_rubocop
    options, paths = RuboCop::Options.new.parse(["."])
    runner = RuboCop::Runner.new(options, RuboCop::ConfigStore.new)
    runner.run(paths)
  end
end
