module Homeland
  module OpensourceProject
    module ApplicationHelper
      delegate :comments_path, to: :main_app

      def opensource_project_user_name_tag(user)
        return '匿名' if user.blank?
        return '官方' if user.admin?
        user_name_tag(user)
      end
    end
  end
end
