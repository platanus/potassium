class Recipes::Database < Rails::AppBuilder
  def ask
    databases = {
      postgresql: "PostgreSQL",
      mysql: "MySQL",
      none: "None, thanks"
    }

    database = answer(:db) do
      databases.keys[Ask.list("Which database are you using?", databases.values)]
    end

    set :database, database.to_sym
  end

  def create
    if db = databases(get(:database))
      if db[:relational]
        activate_for_active_record(db)
      end
    end
  end

  def install
    ask
    create
  end

  private

  def databases(database)
    databases = {
      postgresql: { name: 'postgresql', gem_name: 'pg', relational: true },
      mysql: { name: 'mysql', gem_name: 'mysql2', version: '~> 0.3.18', relational: true }
    }
    databases[database]
  end

  def activate_for_active_record(db)
    remove_file 'config/database.yml'
    template "../assets/config/database_#{db[:name]}.yml.erb", 'config/database.yml'
    discard_gem 'sqlite3'
    if db[:version]
      gather_gem db[:gem_name], db[:version]
    else
      gather_gem db[:gem_name]
    end
  end
end
