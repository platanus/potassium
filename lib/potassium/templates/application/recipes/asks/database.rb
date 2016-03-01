databases = {
  mysql: "MySQL",
  postgresql: "PostgreSQL",
  none: "None, thanks"
}

database = answer(:db) do
  databases.keys[Ask.list("Which database are you using?", databases.values)]
end

set :database, database.to_sym
