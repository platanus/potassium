class Recipes::Api < Recipes::Base
  def ask
    api_support = t.answer(:api) { Ask.confirm("Do you want to enable API support?") }
    t.set(:api_support, api_support)
  end

  def create
    add_api if t.get(:api_support)
  end

  def install
    if t.gem_exists?(/versionist/)
      t.info "API related stuff are already installed"
    else
      add_api
    end
  end

  private

  def add_api
    t.gather_gem 'versionist'
    t.gather_gem 'responders'
    t.gather_gem 'active_model_serializers', '~> 0.9.3'
    t.gather_gem 'simple_token_authentication', '~> 1.0'

    t.after(:gem_install) do
      line = "Rails.application.routes.draw do\n"
      insert_into_file "config/routes.rb", after: line do
        <<-HERE.gsub(/^ {8}/, '')
          scope path: '/api' do
            api_version(module: "Api::V1", path: { value: "v1" }) do
            end
          end
        HERE
      end

      copy_file '../assets/api/base_controller.rb', 'app/controllers/api/v1/base_controller.rb'
      copy_file '../assets/api/api_error_concern.rb', 'app/controllers/concerns/api_error_concern.rb'
      copy_file '../assets/api/responder.rb', 'app/responders/api_responder.rb'
    end
  end
end
