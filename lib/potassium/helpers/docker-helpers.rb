class DockerHelpers
  def initialize(compose_path)
    @compose_path = compose_path
    @compose = YAML.safe_load(File.read(compose_path))
  end

  def add_link(target_service, linked_service)
    service = @compose['services'][target_service]
    unless service['links'].is_a? Array
      service['links'] = []
    end
    service['links'].push(linked_service)
    save
  end

  def add_env(target_service, variable_key, variable_value)
    service = @compose['services'][target_service]
    unless service['environment'].is_a? Hash
      service['environment'] = {}
    end
    service['environment'][variable_key] = variable_value
    save
  end

  def add_service(name, definition)
    add_leaf('services', name, definition)
  end

  def add_volume(name, definition = '')
    add_leaf('volumes', name, definition)
  end

  private

  def add_leaf(root_name, leaf_name, definition)
    leaf = {}
    leaf[leaf_name] = YAML.safe_load(definition)
    @compose[root_name] = {} unless @compose[root_name].is_a? Hash
    @compose[root_name].merge!(leaf)
    save
  end

  def save
    File.open(@compose_path, 'w') { |f| f.write @compose.to_yaml }
  end
end
