module VariableHelpers
  def set(key, value)
    @_data ||= {}
    @_data[key] = value
  end

  def selected?(key, value = nil)
    value ? equals?(key, value) : get(key)
  end

  def get(key)
    @_data ||= {}
    @_data[key]
  end

  def equals?(key, value)
    get(key) == value
  end

  def exists?(key)
    equals?("#{key}_exists".to_sym, true)
  end

  private

  def ensure_variable(key, default_value)
    set(key, get(key) || default_value)
  end
end
