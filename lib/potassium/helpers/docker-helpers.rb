class DockerHelpers
  def initialize(compose_path)
    @compose_path = compose_path
    @compose = YAML.load(File.read(compose_path))
  end

  def add_link(target_service, linked_service)
    service = @compose[:services][target_service]
    unless service['links'].is_a? Array
      service['links'] = []
    end
    service['links'].push(linked_service)
    save
  end

  def add_env(target_service, variable_key, variable_value)
    service =  @compose[:services][target_service]
    unless service['environment'].is_a? Hash
      service['environment'] = {}
    end
    service['environment'][variable_key] = variable_value
    save
  end

  def add_service(name, definition)
    service = {}
    service[name] = YAML.load(definition)
    @compose[:sevices].merge!(service)
    save
  end

  private

  def save
    File.open(@compose_path, 'w') { |f| f.write @compose.to_yaml }
  end
end
