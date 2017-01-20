Rake::Task['db:setup'].enhance do
  Rake::Task['db:fake_data:load'].invoke if Rails.env.development?
end

namespace :db do
  namespace :fake_data do
    desc "Loads development's fake data."
    task load: :environment do
      require 'fake_data_loader.rb'

      if Rails.env.production?
        puts "You can't run this task on production environment"
        return
      end

      FakeDataLoader.load
    end
  end
end
