module ReadmeHelpers
  def add_to_readme(header, key, iterpolation_values = {})
    section_data = readme_data(header, key, iterpolation_values)
    return unless section_data
    add_section_to_readme(section_data)
  end

  def add_section_to_readme(section_data)
    add_header_to_readme(section_data[:header])
    insert_into_readme(section_data[:header]) do
      <<-HERE.gsub(/^ {6}/, '')

      ### #{section_data[:title]}

      #{section_data[:body]}
      HERE
    end
  end

  def add_header_to_readme(header)
    return if read_file("README.md").match("## #{header}")
    insert_into_readme do
      <<-HERE.gsub(/^ {6}/, '')
      ## #{header}
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
    file = File.expand_path("../../assets/README.yml", __FILE__)
    YAML.load(File.read(file))
  end

  def insert_into_readme(after_text = nil, &block)
    if after_text
      line = "#{after_text}\n"
      insert_into_file "README.md", after: line do
        block.call
      end
    else
      append_to_file "README.md" do
        block.call
      end
    end
  end
end
