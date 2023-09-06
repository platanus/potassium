RSpec.shared_context 'with pundit setup' do
  subject(:policy) { described_class }

  let(:admin_user) { create(:admin_user) }
end

RSpec.shared_examples 'pundit back office - grant access to admin' do
  it { expect(policy).to permit(admin_user, record) }
end

RSpec.shared_examples 'pundit back office - forbid access to admin' do
  it { expect(policy).not_to permit(admin_user, record) }
end

RSpec.shared_examples 'pundit back office - default permissions' do
  it_behaves_like 'pundit back office - default show action'
  it_behaves_like 'pundit back office - default index action'
  it_behaves_like 'pundit back office - default update action'
  it_behaves_like 'pundit back office - default edit action'
  it_behaves_like 'pundit back office - default new action'
  it_behaves_like 'pundit back office - default create action'
  it_behaves_like 'pundit back office - default destroy action'
end

RSpec.shared_examples 'pundit back office - default permission' do
  it_behaves_like 'pundit back office - grant access to admin'
end

RSpec.shared_examples 'pundit back office - default show action' do
  permissions :show? do
    it_behaves_like 'pundit back office - default permission'
  end
end

RSpec.shared_examples 'pundit back office - default index action' do
  permissions :index? do
    it_behaves_like 'pundit back office - default permission'
  end
end

RSpec.shared_examples 'pundit back office - default create action' do
  permissions :create? do
    it_behaves_like 'pundit back office - default permission'
  end
end

RSpec.shared_examples 'pundit back office - default update action' do
  permissions :update? do
    it_behaves_like 'pundit back office - default permission'
  end
end

RSpec.shared_examples 'pundit back office - default new action' do
  permissions :new? do
    it_behaves_like 'pundit back office - default permission'
  end
end

RSpec.shared_examples 'pundit back office - default edit action' do
  permissions :edit? do
    it_behaves_like 'pundit back office - default permission'
  end
end

RSpec.shared_examples 'pundit back office - default destroy action' do
  permissions :destroy? do
    it_behaves_like 'pundit back office - default permission'
  end
end
