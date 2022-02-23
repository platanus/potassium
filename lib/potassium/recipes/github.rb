require 'octokit'

class Recipes::Github < Rails::AppBuilder
  def ask
    github_repo_create = answer(:github) do
      Ask.confirm('Do you want to create a Github repository?')
    end
    set(:github_repo, github_repo_create)
    setup_repo if github_repo_create
  end

  def setup_repo
    setup_repo_private
    setup_repo_org
    setup_repo_name
    set(:github_access_token, get_access_token)
  end

  def create
    return unless selected?(:github_repo)

    create_github_repo
    copy_file '../assets/.github/pull_request_template.md', '.github/pull_request_template.md'
  end

  private

  def setup_repo_private
    repo_private = answer(:github_private) do
      Ask.confirm('Should the repository be private?')
    end
    set(:github_repo_private, repo_private)
  end

  def setup_repo_org
    has_organization = answer(:github_has_org) do
      Ask.confirm('Is this repo for a Github organization?')
    end
    set(:github_has_org, has_organization)
    if has_organization
      repo_organization = answer(:github_org) do
        Ask.input('What is the organization for this repository?', default: 'platanus')
      end
      set(:github_org, repo_organization)
    end
  end

  def setup_repo_name
    repo_name = answer(:github_name) do
      Ask.input('What is the name for this repository?', default: get(:dasherized_app_name))
    end
    set(:github_repo_name, repo_name)
  end

  def create_github_repo
    options = { private: get(:github_repo_private) }
    options[:organization] = get(:github_org) if get(:github_has_org)
    repo_name = get(:github_repo_name)

    is_retry = false
    begin
      github_client(is_retry).create_repository(repo_name, options)
    rescue Octokit::Unauthorized
      is_retry = true
      retry if retry_create_repo
    end
  end

  def retry_create_repo
    Rails.logger.debug "Bad credentials, information on Personal Access Tokens here:"
    Rails.logger.debug "https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token"
    Rails.logger.debug "Make sure to give repo access to the personal access token"
    Ask.confirm("Do you want to retry?")
  end

  def github_client(is_retry = false)
    access_token = is_retry ? set_access_token : get(:github_access_token)
    octokit_client.new(access_token: access_token)
  end

  def octokit_client
    if answer(:test)
      require_relative '../../../spec/support/fake_octokit'
      FakeOctokit
    else
      Octokit::Client
    end
  end

  def get_access_token
    return File.open(config_filename, 'r').read if File.exists?(config_filename)

    set_access_token
  end

  def set_access_token
    access_token = answer(:github_access_token) do
      Ask.input('Enter a GitHub personal access token', password: true)
    end
    File.open(config_filename, 'w') { |f| f.write(access_token) }
    access_token
  end

  def config_filename
    @config_filename ||= File.expand_path('~/.potassium')
  end
end
