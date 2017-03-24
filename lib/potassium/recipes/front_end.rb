class Recipes::FrontEnd < Rails::AppBuilder
  def ask
    frameworks = {
      vue: "Vue",
      angular: "Angular",
      none: "None"
    }

    framework = answer(:front_end) do
      frameworks.keys[
        Ask.list("Which front-end framework are you going to use?", frameworks.values)
      ]
    end

    set :front_end, framework.to_sym
  end

  def create
    gather_gem 'webpacker', github: 'rails/webpacker'

    after(:gem_install) do
      value = get(:front_end)
      run "rails webpacker:install"
      run "rails webpacker:install:#{value}" if value

      if value == :vue
        application_js_file = "app/javascript/packs/application.js"
        FileUtils.move "app/javascript/packs/hello_vue.js", application_js_file
        gsub_file application_js_file, /\/\/.*\n/, ""

        js_pack_tag = "\n    <%= javascript_pack_tag 'application' %>\n"
        layout_file = "app/views/layouts/application.html.erb"
        insert_into_file layout_file, js_pack_tag, after: "<%= csrf_meta_tags %>"
      end
    end
  end

  def install
    ask
    create
  end

  private

  def frameworks(framework)
    frameworks = {
      vue: "vue",
      angular: "angular",
      none: nil
    }
    frameworks[framework]
  end
end
