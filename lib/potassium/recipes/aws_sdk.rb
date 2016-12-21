class Recipes::AwsSdk < Rails::AppBuilder
  def create
    gather_gem('aws-sdk')
  end
end
