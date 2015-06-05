if get(:api_support)
  gather_gem 'versionist'

  after(:gem_install) do
    line = "Rails.application.routes.draw do"
    routes = "config/routes.rb"
    gsub_file routes, /(#{Regexp.escape(line)})/mi do |match|
      <<-HERE.gsub(/^ {9}/, '')
         api_version(:module => "Api::V1", :path => {:value => "v1"}) do
         end
         HERE
    end

    copy_file 'assets/api/base_controller.rb', 'app/controllers/api/v1/base_controller'
  end
end
