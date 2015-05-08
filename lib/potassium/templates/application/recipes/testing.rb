gather_gems(:development, :test) do
  gather_gem('rspec-rails')
  gather_gem('factory_girl_rails')
  gather_gem('guard-rspec', require: false)
  gather_gem('rspec-nc', require: false)
end

gather_gems(:test) do
  gather_gem('shoulda-matchers', require: false)
end

after(:gem_install) do
  remove_dir 'test'

  generate "rspec:install"

  remove_file 'spec/rails_helper.rb'
  copy_file 'assets/testing/rails_helper.rb', 'spec/rails_helper.rb'

  remove_file '.rspec'
  copy_file 'assets/testing/.rspec', '.rspec'

  empty_directory 'spec/support'
  create_file 'spec/support/.keep'

  run "guard init"
end
