RSpec.describe BackOffice::ActiveAdmin::CommentPolicy do
  include_context 'with pundit setup'

  let(:record) { instance_double('ActiveAdmin::Comment') }

  it_behaves_like 'pundit back office - default permissions'
end
