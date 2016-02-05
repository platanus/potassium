if get(:heroku)
  gather_gems(:development, :test) do
    gather_gem('rails_stdout_logging')
  end

  copy_file 'assets/Procfile', 'Procfile'
  copy_file 'assets/.buildpacks', '.buildpacks'
end
