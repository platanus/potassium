class Recipes::ReviewApps < Rails::AppBuilder
  def ask
    return unless get(:heroku)

    review_apps = answer(:review_apps) do
      Ask.confirm("Do you want to enable review apps?")
    end

    set(:review_apps, review_apps) if review_apps
  end

  def create
    add_review_apps if get(:review_apps)
  end

  def install; end

  def installed?
    file_exist?('app.json')
  end

  private

  def add_review_apps
    template('../assets/app.json.erb', 'app.json')
    merge_to_json_file('app.json', worker_dyno_config) if get(:background_processor)
    setup_review_apps_on_heroku
    # destroy_authorization_token
    # add_readme_header :review_apps
  end

  def setup_review_apps_on_heroku
    run "curl -i -X POST -H \"Authorization: Bearer #{authorization_token}\" -H \"Accept: application/vnd.heroku+json; version=3\" -H \"Content-Type: application/json\" -d '{ \"repo\": \"#{github_repo_name}\", \"automatic_review_apps\": false, \"destroy_stale_apps\": true, \"stale_days\": 1, \"base_name\": \"pl-#{pipeline_name}\"}' https://api.heroku.com/pipelines/#{pipeline_id}/review-app-config"
  end

  def authorization_id
    authorization['id']
  end

  def pipeline_id
    pipeline_info['pipeline']['id']
  end

  def authorization_token
    authorization['access_token']['token']
  end

  def github_repo_name
    "#{get(:github_org) || github_user[:login]}/#{get(:github_repo_name)}"
  end

  def github_user
    github_client.user
  end

  def destroy_authorization_token
    run "heroku authorizations:revoke '#{authorization_id}'"
  end

  def authorization
    @authorization ||= JSON.parse(
      `heroku authorizations:create --json \
        --description '#{authorization_description}' \
        --expires-in #{authorization_expires_in}`
    )
  end

  def pipeline_name
    get(:heroku_pipeline_name)
  end

  def pipeline_info
    @pipeline_info ||= JSON.parse(`heroku pipelines:info #{pipeline_name} --json`)
  end

  def github_client
    @github_client ||= octokit_client.new(access_token: get(:github_access_token))
  end

  def octokit_client
    if answer(:test)
      require_relative '../../../spec/support/fake_octokit'
      FakeOctokit
    else
      Octokit::Client
    end
  end

  def authorization_description
    'Potassium CLI for review apps'
  end

  def authorization_expires_in
    5.minutes
  end

  def worker_dyno_config
    {
      environments: {
        review: {
          formation: {
            worker: { quantity: 1, size: "hobby" }
          }
        }
      }
    }
  end
end
