class ImageUploader < BaseUploader
  def allowed_types
    @allowed_types ||= %w[image/jpeg image/jpg image/png image/svg+xml image/gif].freeze
  end
end
