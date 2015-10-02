if get(:api_support)
  gather_gem 'versionist'
  gather_gem 'responders'
  gather_gem 'active_model_serializers', '~> 0.9.3'
  gather_gem 'simple_token_authentication', '~> 1.0'

  after(:gem_install) do
    line = "Rails.application.routes.draw do\n"
    insert_into_file "config/routes.rb", after: line do
      <<-HERE.gsub(/^ {7}/, '')
        scope path: '/api' do
          api_version(:module => "Api::V1", :path => {:value => "v1"}) do
          end
        end
      HERE
    end

    copy_file 'assets/api/base_controller.rb', 'app/controllers/api/v1/base_controller.rb'
    copy_file 'assets/api/api_error_concern.rb', 'app/controllers/concerns/api_error_concern.rb'
    copy_file 'assets/api/responder.rb', 'app/responders/api_responder.rb'

    application %{
      # Enables root API objects
      ActiveRecord::Base.include_root_in_json = true
    }
  end
end
