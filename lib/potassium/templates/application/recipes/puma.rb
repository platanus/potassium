gather_gems(:production, :staging) do
  gather_gem 'puma'
end

copy_file "assets/config/puma.rb", 'config/puma.rb'
