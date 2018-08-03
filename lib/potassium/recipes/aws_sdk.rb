class Recipes::AwsSdk < Rails::AppBuilder
  def create
    gather_gem('aws-sdk', '~> 3')

    template("../assets/aws.rb", "config/initializers/aws.rb", force: true)
  end
end
