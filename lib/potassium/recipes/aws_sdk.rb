class Recipes::AwsSdk < Rails::AppBuilder
  def create
    gather_gem('aws-sdk', '~> 2.5')
  end
end
