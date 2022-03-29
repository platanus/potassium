require 'shrine'

if Rails.env.development?
  require 'shrine/storage/file_system'

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
  }
elsif Rails.env.production?
  require 'shrine/storage/s3'

  s3_options = {
    bucket: ENV.fetch('S3_BUCKET'),
    region: ENV.fetch('AWS_REGION'),
    access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
    store: Shrine::Storage::S3.new(**s3_options)
  }
else
  require 'shrine/storage/memory'

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :determine_mime_type, analyzer: :marcel
Shrine.plugin :derivatives
Shrine.plugin :default_url
Shrine.plugin :derivation_endpoint, secret_key: ENV.fetch('SHRINE_SECRET_KEY')
Shrine.plugin :refresh_metadata
Shrine.plugin :backgrounding

Shrine::Attacher.promote_block do |attacher|
  ShrinePromoteJob.perform_later(
    attacher.class.name,
    attacher.record.class.name,
    attacher.record.id,
    attacher.name,
    attacher.file_data
  )
end
