databases = {
  "MySQL" => "mysql",
  "PostgreSQL" => "postgresql",
  "None, thanks" => "none"
}

database = databases.values[Ask.list("Which database are you using?", databases.keys)]

set :database, database
