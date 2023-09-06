RSpec.describe BackOffice::AdminUserPolicy do
  include_context 'with pundit setup'

  let(:record) { create(:admin_user) }

  it_behaves_like 'pundit back office - default permissions'
end
