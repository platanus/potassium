class Recipes::FrontEnd < Rails::AppBuilder
  def ask
    frameworks = {
      vue: "Vue",
      angular: "Angular 2",
      react: "React",
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
    return if [:none, :None].include? get(:front_end).to_sym

    gather_gem 'webpacker', github: 'rails/webpacker'

    after(:gem_install) do
      value = get(:front_end)
      run "rails webpacker:install"
      run "rails webpacker:install:#{value}" if value

      if value == :vue
        application_js_file = "app/javascript/packs/application.js"
        FileUtils.move "app/javascript/packs/hello_vue.js", application_js_file
        gsub_file application_js_file, %r{\/\/.*\n}, ""

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

  def installed?
    package_file = 'package.json'
    return false unless file_exist?(package_file)
    package_content = read_file(package_file)
    package_content.include?("\"@angular/core\"") || package_content.include?("\"vue\"")
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
