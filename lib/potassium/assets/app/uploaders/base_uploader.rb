class BaseUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_mime_type store.allowed_types
  end

  def allowed_types
    raise NotImplementedError
  end
end
