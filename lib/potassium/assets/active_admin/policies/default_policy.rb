class BackOffice::DefaultPolicy
  attr_reader :admin_user, :record

  def initialize(admin_user, record)
    @admin_user = admin_user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    true
  end

  class Scope
    attr_reader :admin_user, :scope

    def initialize(admin_user, scope)
      @admin_user = admin_user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
