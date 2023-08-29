class BackOffice::ActiveAdmin::PagePolicy < BackOffice::DefaultPolicy
  def show?
    record.name == 'Dashboard'
  end
end
