class Recipes::Github < Rails::AppBuilder
  def ask
    github_repo_create = answer(:github) do
      Ask.confirm('Do you want to create a Github repository?')
    end
    set(:github_repo, github_repo_create)
    setup_repo if github_repo_create
  end

  def setup_repo
    github_repo_private = answer(:github_private) do
      Ask.confirm('Should the repository be private?')
    end
    github_repo_organization = answer(:github_org) do
      Ask.input('What is the organization or user for this repository?', default: 'platanus')
    end
    github_repo_name = answer(:github_name) do
      Ask.input('What is the name for this repository?', default: get(:dasherized_app_name))
    end
    set(:github_repo_name, "#{github_repo_organization}/#{github_repo_name}")
    set(:github_repo_private, github_repo_private)
  end

  def create
    return unless selected?(:github_repo)

    github_repo_create(get(:github_repo_name), get(:github_repo_private))
    copy_file '../assets/.github/pull_request_template.md', '.github/pull_request_template.md'
  end

  private

  def github_repo_create(repo_name, private_repo = false)
    flag = private_repo ? "-p" : ""
    run "hub create #{flag} #{repo_name}"
  end
end
