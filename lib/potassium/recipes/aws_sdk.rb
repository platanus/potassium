class Recipes::AwsSdk < Recipes::Base
  def create
    t.gather_gem('aws-sdk', '< 2')
  end
end
