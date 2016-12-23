require "paperclip/matchers"

include ActionDispatch::TestProcess

test_files_path = ":rails_root/test_files/:class/:attachment/:id_partition/:filename"
Paperclip::Attachment.default_options[:path] = test_files_path

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/assets"

  config.include Paperclip::Shoulda::Matchers

  config.after(:suite) do
    FileUtils.rm_rf("#{Rails.root}/test_files")
    FileUtils.rm_rf("#{Rails.root}/public/uploads")
  end
end

def fixture_asset(file_name, mime)
  file_path = Rails.root.to_s + "/spec/assets/" + file_name
  fixture_file_upload(file_path, mime)
rescue
  fixture_file_upload(file_name, mime)
end

# GENERAL CONFIG
# On test environment, paperclip attachments will be generated under /test_files directory.
# After running all the specs, the test_files folder will be deleted.
#
# SHOULDA MATCHERS
# Including Paperclip::Shoulda::Matchers will allow you to use special matchers
# to work with paperclip. For example:
#
# describe User do
#   it { should have_attached_file(:avatar) }
#   it { should validate_attachment_presence(:avatar) }
#   it { should validate_attachment_content_type(:avatar).
#                 allowing('image/png', 'image/gif').
#                 rejecting('text/plain', 'text/xml') }
#   it { should validate_attachment_size(:avatar).
#                 less_than(2.megabytes) }
# end
#
# ASSETS
# Your attachments go into /spec/assets directory. You can access them...
#
# From your factories:
#
# FactoryGirl.define do
#   factory :ticket do
#     attachment { fixture_asset("platanus.png", "image/png") }
#   end
# end
#
# From your specs:
#
# it "gets file name" do
#   expect(fixture_asset("platanus.png", "image/png").original_filename).to eq("platanus.png")
# end
