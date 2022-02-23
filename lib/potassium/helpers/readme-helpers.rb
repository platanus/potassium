module ReadmeHelpers
  def add_readme_section(header, section, iterpolation_values = {})
    section_data = readme_section_data(header, section, iterpolation_values)
    add_readme_header(header, iterpolation_values)

    insert_into_readme(section_data[:header_title]) do
      <<~HERE

        ### #{section_data[:title]}

        #{section_data[:body]}
      HERE
    end
  end

  def add_readme_header(header, iterpolation_values = {})
    header_data = readme_header_data(header, iterpolation_values)
    return if read_file("README.md").match("## #{header_data[:title]}")

    if header_data[:body]
      insert_into_readme do
        <<~HERE

          ## #{header_data[:title]}

          #{header_data[:body]}
        HERE
      end
    else
      insert_into_readme do
        <<~HERE

          ## #{header_data[:title]}
        HERE
      end
    end
  end

  def readme_header_data(header, iterpolation_values)
    file = get_readme
    header_data = file["readme"]["headers"][header.to_s]

    {
      title: header_data["title"],
      body: interpolate_text(header_data["body"], iterpolation_values)
    }
  end

  def readme_section_data(header, section, iterpolation_values)
    file = get_readme
    header_data = file["readme"]["headers"][header.to_s]
    section_data = header_data["sections"][section.to_s]

    {
      header_title: header_data["title"],
      title: interpolate_text(section_data["title"], iterpolation_values),
      body: interpolate_text(section_data["body"], iterpolation_values)
    }
  end

  def interpolate_text(text, iterpolation_values)
    return unless text

    b = binding
    iterpolation_values.each { |k, v| singleton_class.send(:define_method, k) { v } }
    ERB.new(text).result(b)
  end

  def get_readme
    file = File.expand_path('../assets/README.yml', __dir__)
    YAML.safe_load(File.read(file))
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
