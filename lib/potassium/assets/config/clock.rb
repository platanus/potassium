require 'clockwork'
require_relative './boot'
require_relative './environment'

module Clockwork
  # Example
  #
  # every(5.minutes, 'ScheduledJob') do
  #   ScheduledJob.perform_later
  # end
end
