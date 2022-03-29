class Shrine
  module Plugins
    module ImageHandlingUtilities
      # rubocop:disable Metrics/ModuleLength
      module AttachmentMethods
        def included(klass)
          super

          define_instance_methods
          define_class_methods(klass)
        end

        private

        def define_instance_methods
          define_with_stored_attacher_method
          define_blurhash_instance_method
          define_generate_derivatives_instance_method
          define_generate_metadata_instance_method
          define_generate_derivatives_and_metadata_instance_method
        end

        def define_blurhash_instance_method
          name = @name
          define_method(:"#{@name}_blurhash") do
            send(name)&.metadata&.[]('blurhash')
          end
        end

        def define_generate_derivatives_instance_method
          name = @name
          define_method(:"generate_#{name}_derivatives") do
            send("with_stored_#{name}_attacher") do |attacher|
              old_derivatives = attacher.derivatives

              attacher.set_derivatives({})
              attacher.create_derivatives

              begin
                attacher.atomic_persist
                attacher.delete_derivatives(old_derivatives) if old_derivatives.present?
              rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
                attacher.delete_derivatives
              end
            end
          end
        end

        def define_generate_metadata_instance_method
          name = @name
          define_method(:"generate_#{name}_metadata") do
            send("with_stored_#{name}_attacher") do |attacher|
              attacher.refresh_metadata!
              attacher.atomic_persist
            end
          end
        end

        # rubocop:disable Metrics/MethodLength
        def define_generate_derivatives_and_metadata_instance_method
          name = @name
          define_method(:"generate_#{name}_derivatives_and_metadata") do
            send("with_stored_#{name}_attacher") do |attacher|
              old_derivatives = attacher.derivatives

              attacher.set_derivatives({})
              attacher.file.open do
                attacher.create_derivatives
                attacher.refresh_metadata!
              end

              begin
                attacher.atomic_persist
                attacher.delete_derivatives(old_derivatives) if old_derivatives.present?
              rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
                attacher.delete_derivatives
              end
            end
          end
        end
        # rubocop:enable Metrics/MethodLength

        def define_class_methods(klass)
          define_generate_all_derivatives_class_method(klass)
          define_generate_all_metadata_class_method(klass)
          define_generate_all_derivatives_and_metadata_class_method(klass)
        end

        def define_generate_all_derivatives_class_method(klass)
          name = @name
          klass.send(
            :define_singleton_method, :"generate_all_#{name}_derivatives"
          ) do |&error_block|
            all.find_each do |record|
              record.send(:"generate_#{name}_derivatives")
            rescue StandardError => e
              error_block.call(record, e) if error_block.present?
            end
          end
        end

        def define_generate_all_metadata_class_method(klass)
          name = @name
          klass.send(:define_singleton_method, :"generate_all_#{name}_metadata") do |&error_block|
            all.find_each do |record|
              record.send(:"generate_#{name}_metadata")
            rescue StandardError => e
              error_block.call(record, e) if error_block.present?
            end
          end
        end

        def define_generate_all_derivatives_and_metadata_class_method(klass)
          name = @name
          klass.send(
            :define_singleton_method, :"generate_all_#{name}_derivatives_and_metadata"
          ) do |&error_block|
            all.find_each do |record|
              record.send(:"generate_#{name}_derivatives_and_metadata")
            rescue StandardError => e
              error_block.call(record, e) if error_block.present?
            end
          end
        end

        def define_with_stored_attacher_method
          name = @name
          define_method(:"with_stored_#{name}_attacher") do |&block|
            return if send(name).blank?

            attacher = send(:"#{name}_attacher")

            block.call(attacher) if attacher.stored?
          end
          private :"with_stored_#{name}_attacher"
        end
      end
      # rubocop:enable Metrics/ModuleLength
    end

    register_plugin(:image_handling_utilities, ImageHandlingUtilities)
  end
end
