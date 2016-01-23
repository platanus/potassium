def activate_for_active_record(db)
  remove_file 'config/database.yml'
  template "assets/config/database_#{db[:name]}.yml.erb", 'config/database.yml'

  discard_gem 'sqlite3'
  if db[:version]
    gather_gem db[:gem_name], db[:version]
  else
    gather_gem db[:gem_name]
  end
end

databases = {
  mysql: { name: 'mysql', gem_name: 'mysql2', version: '~> 0.3.18', relational: true },
  postgresql: { name: 'postgresql', gem_name: 'pg', relational: true }
}

if db = databases[get(:database).to_sym]
  if db[:relational]
    activate_for_active_record(db)
  end
end
