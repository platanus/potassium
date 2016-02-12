gather_gems(:development, :test) do
  gather_gem('dotenv-rails')
end

template 'assets/.env.example.erb', '.env.example'
run "cp .env.example .env"
