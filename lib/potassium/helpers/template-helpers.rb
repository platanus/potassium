module TemplateHelpers
  def load_recipe(recipe)
    get_recipe_class(recipe).new(self)
  end

  def get_recipe_class(recipe)
    require_relative "../recipes/#{recipe}"
    Recipes.const_get(recipe.camelize)
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
end
