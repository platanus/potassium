RSpec.shared_examples "name" do
  it { expect(sidekiq_config).to include("- mailers") }
  it { expect(env).to include("EMAIL_RECIPIENTS") }
  it { expect(dev_config).to include(asset_host_dev) }
end
