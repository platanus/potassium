module CallbackHelpers
  def after(action_name, wrap_in_action: false, &action)
    ensure_callbacks_variables_for_action(action_name)

    if get(:executed_actions).include?(action_name)
      instance_exec(&wrap_action(action, wrap_in_action))
    else
      add_callback(action_name, :after, wrap_action(action, wrap_in_action))
    end
  end

  def before(action_name, wrap_in_action: false, &action)
    ensure_callbacks_variables_for_action(action_name)
    add_callback(action_name, :before, action)
  end

  def run_action(action_name, &action)
    ensure_callbacks_variables_for_action(action_name)
    callbacks = get(:callbacks)[action_name]

    callbacks[:before].each { |callback| instance_exec(&callback) }
    instance_exec(&action)
    get(:executed_actions) << action_name
    callbacks[:after].each { |callback| instance_exec(&callback) }
  end

  private

  def add_callback(action_name, type, action)
    get(:callbacks)[action_name][type] << action
  end

  def wrap_action(action, wrap_in_action)
    return action unless wrap_in_action
    ->{ run_action(wrap_in_action, &action) }
  end

  def ensure_callbacks_variables_for_action(action_name)
    ensure_variable(:callbacks, {})
    ensure_variable(:executed_actions, [])
    get(:callbacks)[action_name] ||= { before: [], after: [] }
  end
end
