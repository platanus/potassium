RSpec.describe BackOffice::DefaultPolicy do
  include_context 'with pundit setup'

  let(:record) { double }

  it_behaves_like 'pundit back office - default permissions'
end
