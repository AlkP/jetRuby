class AppointmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  def index?    ; user.present? ; end
  def new?      ; user.present? ; end
  def create?   ; user.present? ; end
  def update?   ; record.state == 'pending' ; end
  def destroy?  ; record.state == 'pending' ; end
  def request_remind?  ; record.state == 'confirmed' ; end
  def create_remind?  ; record.state == 'confirmed' ; end

end
