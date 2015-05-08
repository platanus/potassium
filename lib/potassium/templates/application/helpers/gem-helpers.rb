module GemHelpers
  def gather_gem(name, *attributes)
    ensure_variable(:gems, {})
    current_gem_groups = get(:current_gem_groups) || [:base]

    get(:gems)[current_gem_groups] ||= []
    get(:gems)[current_gem_groups] << { name: name, attributes: attributes }
  end

  def discard_gem(name)
    get(:gems).each do |environments, gems|
      gems.delete_if do |gem_entry|
        gem_entry[:name] == name
      end
    end
  end

  def gather_gems(*environments, &block)
    ensure_variable(:gems, {})
    set(:current_gem_groups, environments)
    instance_exec(&block)
    set(:current_gem_groups, [:base])
  end

  def clean_gemfile
    remove_everything_but_source
    add_original_rails_gems
  end

  def build_gemfile
    call_gem_for_gathered_gems
    fix_withespace_issues
  end

  private

  def call_gem_for_gathered_gems
    ensure_variable(:gems, {})
    gems = get(:gems)

    base_gems = gems.delete([:base]) || []

    call_gem_for_gems(base_gems)

    gems.each do |environments, env_gems|
      gem_group *environments do
        call_gem_for_gems(env_gems)
      end
    end
  end

  def call_gem_for_gems(gems)
    gems.each(&method(:call_gem_for_gem))
  end

  def call_gem_for_gem(gem_data)
    gem gem_data[:name], *gem_data[:attributes]
  end

  def add_original_rails_gems
    gemfile_entries.each do |entry|
      unless entry.commented_out
        gather_gem(entry.name, entry.version)
      end
    end
  end

  def remove_everything_but_source
    gsub_file("Gemfile", /[\w\W]+/, "source 'https://rubygems.org'\n")
  end

  def fix_withespace_issues
    gsub_file("Gemfile", /^group/, "\ngroup")
  end
end
