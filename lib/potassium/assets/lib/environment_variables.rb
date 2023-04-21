module EnvironmentVariables
  extend self

  APPLICATION_HOST = ENV.fetch('APPLICATION_HOST')

  def application_host
    APPLICATION_HOST
  end
end
