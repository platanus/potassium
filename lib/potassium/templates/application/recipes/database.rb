def activate_for_active_record(db)
  remove_file 'config/database.yml'
  copy_file "assets/config/database_#{db[:name]}.yml", 'config/database.yml'

  discard_gem 'sqlite3'
  gather_gem db[:gem_name]
end

databases = {
  mysql: { name: 'mysql', gem_name: 'mysql2', relational: true },
  postgresql: { name: 'postgresql', gem_name: 'pg', relational: true }
}

if db = databases[get(:database).to_sym]
  if db[:relational]
    activate_for_active_record(db)
  end
end
