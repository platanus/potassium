module EnvironmentHelpers
  def set_env(key, value)
    ensure_variable(:default_env, {})
    get(:default_env)[key] = value
    ENV[key] = value
  end

  def get_env(key)
    ensure_variable(:default_env, {})
    get(:default_env)[key]
  end

  def default_env(hash = {})
    hash.each do |key, value|
      set_env(key, value)
    end
  end
end
