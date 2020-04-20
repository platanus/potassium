class BaseUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_mime_type allowed_types
  end

  private

  def allowed_types
    raise NotImplementedError
  end
end
