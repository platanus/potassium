module InfoHelpers
  def success(message)
    say(message, :green)
    true
  end

  def error(message)
    say(message, :red)
    false
  end

  def info(message)
    say(message, :yellow)
    true
  end
end
