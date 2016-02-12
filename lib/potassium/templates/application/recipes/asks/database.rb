databases = {
  mysql: "MySQL",
  postgresql: "PostgreSQL",
  none: "None, thanks"
}

database = databases.keys[Ask.list("Which database are you using?", databases.values)]

set :database, database
