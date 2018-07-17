module Potassium::CliOptions # rubocop:disable Metrics/ModuleLength
  CREATE_OPTIONS = [
    {
      type: :flag,
      name: [:db, :database],
      desc: "Decides which database to use. Available: mysql, postgresql, none",
      default_test_value: "postgresql"
    },
    {
      type: :flag,
      name: "locale",
      desc: "Decides which locale to use. Available: es-CL, en",
      default_test_value: "es-CL"
    },
    {
      type: :flag,
      name: [:email_service, :email],
      desc: "Decides which email adapter to use. Available: aws_ses, sendgrid, none",
      default_test_value: "aws_ses"
    },
    {
      type: :switch,
      name: "devise",
      desc: "Whether to use Devise for authentication or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "devise-user-model",
      desc: "Whether to create a User model for Devise",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "admin",
      desc: "Whether to use ActiveAdmin or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "angular-admin",
      desc: "Whether to use Angular within ActiveAdmin or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "pundit",
      desc: "Whether to use Pundit for authorization or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "api",
      desc: "Whether to apply the API mode or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "paperclip",
      desc: "Whether to include Paperclip as dependency",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "active_storage",
      desc: "Whether to include Active Storage as dependency",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "heroku",
      desc: "Whether to prepare to application for Heroku or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :flag,
      name: "background_processor",
      desc: "Decides which background processor to use. Available: sidekiq, delayed_job, none",
      default_test_value: "sidekiq"
    },
    {
      type: :switch,
      name: "draper",
      desc: "Whether to use Draper or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "github",
      desc: "Whether to create a github repository",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "github-private",
      desc: "Whether to the github repository is private",
      negatable: true,
      default_value: false,
      default_test_value: false
    },
    {
      type: :switch,
      name: "schedule",
      desc: "Whether to use sidekiq-scheduler as job scheduler",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "sentry",
      desc: "Whether to use Sentry as error reporting tool",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :flag,
      name: :front_end,
      desc: "Decides which front-end framework to use. Available: Vue, Angular 2, None",
      default_test_value: "None"
    }
  ]

  def create_options(test_env = false)
    CREATE_OPTIONS.map do |opts|
      opts = opts.dup
      test_default_value = opts.delete(:default_test_value)
      opts[:default_value] = test_default_value if test_env
      opts
    end
  end

  def create_arguments(test_env = false)
    create_options(test_env).inject({}) do |memo, opts|
      opt = opts[:name].is_a?(Array) ? opts[:name].first : opts[:name]
      memo[opt.to_s] = opts[:default_value]
      memo
    end
  end
end
