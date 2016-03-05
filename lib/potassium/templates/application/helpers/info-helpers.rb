module InfoHelpers
  def success(message)
    say(message, :green)
  end

  def error(message)
    say(message, :red)
  end

  def info(message)
    say(message, :yellow)
  end
end
