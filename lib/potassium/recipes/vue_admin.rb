class Recipes::VueAdmin < Rails::AppBuilder
  def ask
    if selected?(:admin_mode)
      vue_admin = answer(:vue_admin) do
        Ask.confirm "Do you want Vue support for ActiveAdmin?"
      end
      set(:vue_admin, vue_admin)
    end
  end

  def create
    recipe = self
    if selected?(:vue_admin)
      after(:admin_install) do
        recipe.add_vue_admin
      end
    end
  end

  def install
    active_admin = load_recipe(:admin)
    if active_admin.installed?
      add_vue_admin
      info "VueAdmin installed"
    else
      info "VueAdmin can't be installed because Active Admin isn't installed."
    end
  end

  def installed?
    file_exist?("lib/vue_component.rb")
  end

  def add_vue_admin
    add_vue_component_library
    add_component_integration
    insert_into_file(
      'app/frontend/entrypoints/active_admin.js',
      active_admin_js
    )
    copy_file '../assets/active_admin/admin-component.vue',
              'app/frontend/components/admin-component.vue',
              force: true
  end

  def add_component_integration
    line = "class CustomFooter < ActiveAdmin::Component"
    initializer = "config/initializers/active_admin.rb"
    gsub_file initializer, /(#{Regexp.escape(line)})/mi do |_match|
      <<~HERE
        require "vue_component.rb"
        AUTO_BUILD_ELEMENTS=[:admin_component, :template, :slot]
        component_creator(AUTO_BUILD_ELEMENTS)

        #{line}
      HERE
    end
  end

  def add_vue_component_library
    lib_component_path = "lib/vue_component.rb"
    class_definitions =
      <<~HERE
        #{vue_component}
        #{component_builder}
      HERE
    File.open(lib_component_path, "w") { |file| file.write(class_definitions) }
  end

  def vue_component
    <<~HERE
      class VueComponent < Arbre::Component
        builder_method :root
        def tag_name
          :root
        end

        def initialize(*)
          super
        end

        def build(attributes = {})
          super(process_attributes(attributes))
        end

        def process_attributes(attributes)
          vue_attributes = {}
          attributes.each do |key, value|
            dasherized_key = key.to_s.dasherize
            if value.is_a?(String)
              vue_attributes[dasherized_key] = value
            elsif !dasherized_key.index(':').nil? && dasherized_key.index(':').zero?
              vue_attributes[dasherized_key] = value.to_json
            else
              vue_attributes[":" + dasherized_key] = value.to_json
            end
          end
          vue_attributes
        end
      end
    HERE
  end

  def component_builder
    <<~HERE
      def component_creator(auto_build_elements)
        auto_build_elements.each do |element|
          as_string=element.to_s
          camelized_element = as_string.camelize
          Object.const_set(camelized_element,Class.new(VueComponent))
          Object.const_get(camelized_element).class_eval do
            builder_method as_string.to_sym
            def tag_name
              self.class.to_s.underscore
            end
          end
        end
      end
    HERE
  end

  def active_admin_js
    <<~HERE
      import { createApp } from 'vue';
      import AdminComponent from '../components/admin-component.vue';

      function onLoad() {
        if (document.getElementById('wrapper') !== null) {
          const app = createApp({
            mounted() {
              // We need to re-trigger DOMContentLoaded for ArcticAdmin after Vue replaces DOM elements
              window.document.dispatchEvent(new Event('DOMContentLoaded', {
                bubbles: true,
                cancelable: true,
              }));
            },
          });
          app.component('admin_component', AdminComponent);
          app.mount('#wrapper');
        }

        return null;
      }

      document.addEventListener('DOMContentLoaded', onLoad, { once: true });
    HERE
  end
end
