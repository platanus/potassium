class Recipes::AwsSdk < Rails::AppBuilder
  def create
    gather_gem('aws-sdk', '~> 3')
  end
end
