RSpec.describe BackOffice::ActiveAdmin::PagePolicy do
  include_context 'with pundit setup'

  let(:name) { 'Dashboard' }
  let(:record) { instance_double('ActiveAdmin::Page', name: name) }

  permissions :show? do
    it_behaves_like 'pundit back office - grant access to admin'

    context "with name different than 'Dashboard'" do
      let(:name) { 'Not Dashboard' }

      it_behaves_like 'pundit back office - forbid access to admin'
    end
  end
end
