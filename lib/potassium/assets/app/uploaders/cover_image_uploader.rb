require "image_processing/vips"

class CoverImageUploader < ImageUploader
  plugin :derivation_endpoint, prefix: "derivations/cover_image"
  plugin :add_metadata
  plugin :image_handling_utilities

  DERIVATIVES = {
    sm: { size: [426, 240], type: 'jpg' },
    md: { size: [960, 540], type: 'jpg' },
    lg: { size: [1280, 720], type: 'jpg' },
    webp_sm: { size: [426, 240], type: 'webp' },
    webp_md: { size: [960, 540], type: 'webp' },
    webp_lg: { size: [1280, 720], type: 'webp' }
  }

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    DERIVATIVES.reduce({}) do |derivatives_hash, (name, derivative_info)|
      derivatives_hash[name] = vips.convert(derivative_info[:type]).resize_to_limit!(
        *derivative_info[:size]
      )
      derivatives_hash
    end
  end

  derivation :thumbnail do |file, width, height|
    ImageProcessing::Vips
      .source(file)
      .resize_to_limit!(width.to_i, height.to_i)
  end

  Attacher.default_url do |derivative: nil, **|
    file&.derivation_url(:thumbnail, *DERIVATIVES.dig(derivative, :size)) if derivative.present?
  end

  add_metadata :blurhash do |io, derivative: nil, **|
    if derivative.nil?
      Shrine.with_file(io) do |file|
        image = Vips::Image.new_from_file(file.path, access: :sequential)
        image = image.resize(100.0 / image.width)
        flat_rgb_pixels = []
        image.to_a.each do |row|
          row.each { |pixel| flat_rgb_pixels.concat(pixel[0..2])  }
        end

        Blurhash.encode(image.width, image.height, flat_rgb_pixels)
      end
    end
  end
end
