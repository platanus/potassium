class Recipes::Database < Recipes::Base
  def ask
    databases = {
      mysql: "MySQL",
      postgresql: "PostgreSQL",
      none: "None, thanks"
    }

    database = t.answer(:db) do
      databases.keys[Ask.list("Which database are you using?", databases.values)]
    end

    t.set :database, database.to_sym
  end

  def create
    databases = {
      mysql: { name: 'mysql', gem_name: 'mysql2', version: '~> 0.3.18', relational: true },
      postgresql: { name: 'postgresql', gem_name: 'pg', relational: true }
    }

    if db = databases[t.get(:database)]
      if db[:relational]
        activate_for_active_record(db)
      end
    end
  end

  private

  def activate_for_active_record(db)
    t.remove_file 'config/database.yml'
    t.template "assets/config/database_#{db[:name]}.yml.erb", 'config/database.yml'

    t.discard_gem 'sqlite3'
    if db[:version]
      t.gather_gem db[:gem_name], db[:version]
    else
      t.gather_gem db[:gem_name]
    end
  end
end
