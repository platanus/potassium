module RecipeHelpers
  def export(file)
    exported_recipes << File.basename(file, '.rb')
  end
end
