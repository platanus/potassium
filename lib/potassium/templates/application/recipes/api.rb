if get(:api_support)
  gather_gem 'versionist'
  gather_gem 'responders'
  gather_gem 'simple_token_authentication', '~> 1.0'

  after(:gem_install) do
    line = "Rails.application.routes.draw do\n"
    insert_into_file "config/routes.rb", after: line do
      <<-HERE.gsub(/^ {7}/, '')
         api_version(:module => "Api::V1", :path => {:value => "v1"}) do
         end
      HERE
    end

    copy_file 'assets/api/base_controller.rb', 'app/controllers/api/v1/base_controller.rb'
    copy_file 'assets/api/api_error_concern.rb', 'app/controllers/concerns/api_error_concern.rb'
    copy_file 'assets/api/responder.rb', 'app/responders/api_responder.rb'
  end
end
