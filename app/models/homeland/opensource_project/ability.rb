module Homeland::OpensourceProject
  class Ability
    include CanCan::Ability

    attr_reader :user

    def initialize(u)
      @user = u
      if @user.blank?
        roles_for_anonymous
      elsif @user.roles?(:admin)
        can :manage, OpensourceProject
      elsif @user.roles?(:member)
        roles_for_members
      else
        roles_for_anonymous
      end
    end

    protected

    # 普通会员权限
    def roles_for_members
      can :create, OpensourceProject
      can :update, OpensourceProject, user_id: user.id
      can :destroy, OpensourceProject, user_id: user.id, status: OpensourceProject.statuses[:upcoming]
      basic_read_only
    end

    # 未登录用户权限
    def roles_for_anonymous
      cannot :manage, OpensourceProject
      basic_read_only
    end

    def basic_read_only
      can [:read, :upcoming], OpensourceProject
    end
  end
end
