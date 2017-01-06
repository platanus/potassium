["common", Rails.env].each do |seed_file_name|
  begin
    puts "loading #{seed_file_name} seeds..."
    load(Rails.root.join("db", "seeds", "#{seed_file_name}.rb"))
  rescue LoadError
    puts "No db/seeds/#{seed_file_name}.rb file present on #{Rails.env} environment."
  end
end
