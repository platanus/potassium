heroku = answer(:heroku) { Ask.confirm("Are you going to deploy to heroku?") }

set :heroku, heroku if heroku
