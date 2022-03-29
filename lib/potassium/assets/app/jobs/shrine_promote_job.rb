class ShrinePromoteJob < ApplicationJob
  queue_as :default

  def perform(attacher_class, record_class, record_id, name, file_data)
    attacher_class = Object.const_get(attacher_class)
    record         = Object.const_get(record_class).find(record_id)

    attacher = attacher_class.retrieve(model: record, name: name, file: file_data)
    attacher.create_derivatives
    attacher.atomic_promote
  rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
    # attachment has changed or the record has been deleted, nothing to do
  end
end
