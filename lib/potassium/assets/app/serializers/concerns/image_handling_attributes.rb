module ImageHandlingAttributes
  extend ActiveSupport::Concern

  class_methods do
    def add_image_handling_attributes(attachment_name:, derivatives:, include_original_image: false)
      attributes attachment_name, "#{attachment_name}_blurhash".to_sym

      define_method(attachment_name) do
        attachment_hash = derivatives.reduce({}) do |hash, derivative|
          hash[derivative] = { url: object.send("#{attachment_name}_url", derivative) }
          hash
        end
        if include_original_image
          attachment_hash[:original] = { url: object.send("#{attachment_name}_url") }
        end
        attachment_hash
      end
    end
  end
end
