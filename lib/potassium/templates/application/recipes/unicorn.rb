gather_gem 'unicorn-rails'

gather_gems(:production) do
  gather_gem 'unicorn'
end
