require 'pathname'
require 'bundler'
require 'potassium/cli_options'

module PotassiumTestHelpers
  include Potassium::CliOptions

  APP_NAME = "dummy_app"

  def remove_project_directory
    FileUtils.rm_rf(project_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def create_dummy_project(arguments = {})
    Dir.chdir(tmp_path) do
      Bundler.with_unbundled_env do
        add_fakes_to_path
        add_project_bin_to_path
        full_arguments = hash_to_arguments(create_arguments(true).merge(arguments))
        run_command("#{potassium_bin} create #{APP_NAME} #{full_arguments}")
      end
    end
  end

  def drop_dummy_database
    return unless File.exist?(project_path)

    on_project { run_command("bundle exec rails db:drop") }
  end

  def add_project_bin_to_path
    add_to_path project_bin, true
  end

  def add_fakes_to_path
    add_to_path support_bin
  end

  def project_path
    @project_path ||= Pathname.new("#{tmp_path}/#{APP_NAME}")
  end

  def on_project(&block)
    Dir.chdir(project_path) do
      Bundler.with_unbundled_env do
        block.call
      end
    end
  end

  def docker_cleanup
    run_command(`docker-compose -f #{project_path}/docker-compose.yml down --volumes`)
  end

  private

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

  def add_to_path(new_path, append = false)
    ENV['PATH'] = append ? "#{ENV['PATH']}:#{new_path}" : "#{new_path}:#{ENV['PATH']}"
  end

  def project_bin
    File.join(project_path, 'bin')
  end

  def potassium_bin
    File.join(root_path, "bin", "potassium")
  end

  def support_bin
    File.join(root_path, "spec", "fakes", "bin")
  end

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def root_path
    File.expand_path('../..', __dir__)
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
