create_file '.rbenv-vars'
template 'assets/.rbenv-vars.example', '.rbenv-vars.example'
run "cp .rbenv-vars.example .rbenv-vars"
create_file '.ruby-version', '2.2'
