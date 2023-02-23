class Recipes::FrontEndVite < Rails::AppBuilder
  def installed?
    gem_exists?(/vite_rails/)
  end

  def create
    add_vite
  end

  def install
    add_vite
  end

  def add_vite
    gather_gem("vite_rails")
    recipe = self
    after(:gem_install, wrap_in_action: :vite_install) do
      run "yarn install"
      run "bundle exec vite install"
      recipe.add_vite_dev_ws_content_security_policy
      recipe.copy_dotenv_monkeypatch
    end
  end

  def add_vite_dev_ws_content_security_policy
    initializer = "config/initializers/content_security_policy.rb"
    line = "#    policy.style_src *policy.style_src, :unsafe_inline if Rails.env.development?"
    policy = <<~HERE.chomp
      # if Rails.env.development?
      #   policy.connect_src *policy.connect_src,
      #                     "ws://\#{ViteRuby.config.host_with_port}"
      # end
    HERE
    # check if policy already exists
    return if File.read(initializer).include?("policy.connect_src *policy.connect_src")

    inject_into_file initializer, after: line do
      policy
    end
  end

  def copy_dotenv_monkeypatch
    copy_file '../assets/lib/dotenv_monkeypatch.rb',
              'lib/dotenv_monkeypatch.rb', force: true
    insert_into_file(
      "config/application.rb",
      "\nrequire_relative '../lib/dotenv_monkeypatch'\n",
      after: "Bundler.require(*Rails.groups)"
    )
  end
end
