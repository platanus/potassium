class Recipes::Github < Rails::AppBuilder
  def ask
    repo_name = "platanus/#{get(:dasherized_app_name)}"
    github_repo_create = answer(:github) do
      Ask.confirm("Do you want to use create the github repository? (#{repo_name})")
    end
    if github_repo_create
      github_repo_private = answer(:"github-private") do
        Ask.confirm("Should the repository be private?")
      end
    end
    set(:github_repo_name, repo_name)
    set(:github_repo, github_repo_create)
    set(:github_repo_private, github_repo_private)
  end

  def create
    github_repo_create(get(:github_repo_name), get(:github_repo_private)) if selected?(:github_repo)
  end

  private

  def github_repo_create(repo_name, private_repo = false)
    flag = private_repo ? "-p" : ""
    run "hub create #{flag} #{repo_name}"
  end
end
