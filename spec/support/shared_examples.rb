RSpec.shared_examples "name" do
  it { expect(env).to include("EMAIL_RECIPIENTS") }
  it { expect(dev_config).to include(asset_host_dev) }
end
