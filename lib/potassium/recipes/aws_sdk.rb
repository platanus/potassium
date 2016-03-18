class Recipes::AwsSdk < Rails::AppBuilder
  def create
    gather_gem('aws-sdk', '< 2')
  end
end
