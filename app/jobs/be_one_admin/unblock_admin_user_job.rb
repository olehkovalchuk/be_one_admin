module BeOneAdmin
  class UnblockAdminUserJob < ApplicationJob
    def perform
      BeOneAdmin::User.where(
        "blocked_until < ? AND blocked = ?", Time.zone.now, true
      ).update_all(blocked: false, blocked_until: nil)
    end
  end
end
