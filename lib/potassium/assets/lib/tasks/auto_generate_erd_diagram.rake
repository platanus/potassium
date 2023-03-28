if Rails.env.development?

  tasks = %w(
    db:migrate
    db:migrate:up
    db:migrate:down
    db:migrate:reset
    db:migrate:redo
    db:rollback
    db:migrate:with_data
    db:migrate:up:with_data
    db:migrate:down:with_data
    db:migrate:redo:with_data
    db:rollback:with_data
  )

  tasks.each do |task|
    Rake::Task[task].enhance do
      Rake::Task[Rake.application.top_level_tasks.last].enhance do
        Rake::Task['erd'].invoke
      end
    end
  end
end
