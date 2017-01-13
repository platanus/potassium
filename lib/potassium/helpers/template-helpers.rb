module TemplateHelpers
  def app_name
    @app_name || app_name_from_file
  end

  def load_recipe(recipe_name)
    @recipes ||= {}
    @recipes[recipe_name] ||= get_recipe_class(recipe_name.to_sym).new(self)
  end

  def create(recipe_name)
    recipe = load_recipe(recipe_name)
    recipe.create
  end

  def ask(recipe_name)
    recipe = load_recipe(recipe_name)
    recipe.ask
  end

  def install(recipe_name)
    recipe = load_recipe(recipe_name)

    if !recipe.respond_to?(:installed?) || !recipe.installed? || force?
      recipe.install
    else
      info "#{recipe_name.to_s.titleize} is already installed"
      info "Use --force to force the installation"
    end
  end

  def eval_file(source)
    location = File.expand_path(find_in_source_paths(source))
    unique_name = SecureRandom.hex

    define_singleton_method unique_name do
      instance_eval File.read(location)
    end

    public_send unique_name
  end

  def source_path(path)
    define_singleton_method :source_paths do
      [File.expand_path(File.dirname(path))]
    end
  end

  def erase_comments(file)
    gsub_file file, /^\s*#[^\n]*\n/, ''
  end

  # TODO: Refactor to be able to reuse it and reduce the duplication and confusion.
  def cut_comments(file, limit: 100)
    gsub_file file, /^\s*#[^\n]*\n/ do |match|
      if match.size > limit
        match.partition(/[\w\W]{#{limit - 1}}/).reject(&:blank?).map do |line|
          (line.size == limit - 1) ? "#{line}-" : "# #{line}"
        end.join("\n")
      else
        match
      end
    end
  end

  def file_exist?(file_path)
    File.exist?(file_path)
  end

  def dir_exist?(dir_path)
    Dir.exist?(dir_path)
  end

  def read_file(file_path)
    fail "#{file_path} does not exist in destination" unless file_exist?(file_path)
    File.read(file_path)
  end

  def cli_options
    self.class.cli_options
  end

  def force?
    cli_options[:force]
  end

  def procfile(name, command)
    file = 'Procfile'
    if File.read(file).index(/^#{name}:.*$/m).nil?
      append_file file, "#{name}: #{command}\n"
    else
      gsub_file file, /^name:.*$/m, "#{name}: #{command}\n"
    end
  end

  private

  def get_recipe_class(recipe_name)
    require_relative "../recipes/#{recipe_name}"
    Recipes.const_get(recipe_name.to_s.camelize)
  end

  def app_name_from_file
    File.read('config/application.rb').match(/module\s(.*)/)[1].underscore.dasherize
  end
end
