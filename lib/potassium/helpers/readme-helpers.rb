module ReadmeHelpers
  def add_to_readme(header, key, iterpolation_values = {})
    section_data = readme_data(header, key, iterpolation_values)
    return unless section_data
    add_section_to_readme(section_data)
  end

  def add_section_to_readme(section_data)
    line = "#{section_data[:header]}\n"
    insert_into_file "README.md", after: line do
      <<-HERE.gsub(/^ {6}/, '')

      #{section_data[:title]}

      #{section_data[:body]}

      HERE
    end
  end

  def readme_data(header, key, iterpolation_values)
    file = get_readme
    header_data = file["readme"][header.to_s]
    section_data = header_data["sections"][key.to_s]
    {
      header: header_data["title"],
      title: interpolate_text(section_data["title"], iterpolation_values),
      body: interpolate_text(section_data["body"], iterpolation_values)
    }
  end

  def interpolate_text(text, iterpolation_values)
    b = binding
    iterpolation_values.each { |k, v| b.local_variable_set(k, v) }
    ERB.new(text).result(b)
  end

  def get_readme
    config_path = File.expand_path("../../assets/README.yml", __FILE__)
    YAML.load(File.read(config_path))
  end
end
