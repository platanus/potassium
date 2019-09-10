class Recipes::DataMigrate < Rails::AppBuilder
  def create
    gather_gem('data_migrate')
    annotate_task = 'lib/tasks/auto_annotate_models.rake'
    insert_into_file annotate_task, annotate_config, after: "Annotate.load_tasks\n"
  end

  def install
    create
  end

  def installed?
    gem_exists?(/data_migrate/)
  end

  private

  def annotate_config
    <<-RUBY

  data_migrate_tasks = %w(
    db:migrate:with_data
    db:migrate:up:with_data
    db:migrate:down:with_data
    db:migrate:redo:with_data
    db:rollback:with_data
  )

  data_migrate_tasks.each do |task|
    Rake::Task[task].enhance do
      Rake::Task[Rake.application.top_level_tasks.last].enhance do
        annotation_options_task = if Rake::Task.task_defined?('app:set_annotation_options')
                                    'app:set_annotation_options'
                                  else
                                    'set_annotation_options'
                                  end
        Rake::Task[annotation_options_task].invoke
        Annotate::Migration.update_annotations
      end
    end
  end
    RUBY
  end
end
