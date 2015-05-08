module VariableHelpers
  def set(key, value)
    @_data ||= {}
    @_data[key] = value
  end

  def get(key)
    @_data ||= {}
    @_data[key]
  end

  def equals?(key, value)
    get(key) == value
  end

  private

  def ensure_variable(key, default_value)
    set(key, get(key) || default_value)
  end
end
