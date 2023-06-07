module BeOneAdmin
  class UserPresenter < BasePresenter
    def foto
      @object.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_path(@object.avatar.attachment) : "https://upload.wikimedia.org/wikipedia/commons/1/1e/Default-avatar.jpg"#ActionController::Base.helpers.image_tag("be_one_admin/image.png")

    end
  end
end