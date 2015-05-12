require './app'

namespace :db do
  desc "Run migrations"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate')
  end
end
