module Homeland::OpensourceProject::Admin
  class OpensourceProjectsController < ::Admin::ApplicationController
    layout 'layouts/admin'

    before_action :set_opensource_project, only: [:undestroy, :show, :suggest, :unsuggest]

    def index
      @opensource_projects = OpensourceProject.unscoped.includes(:user).order("id desc").page(params[:page])
    end

    def destroy
      @opensource_project = OpensourceProject.find_by_slug!(params[:id])
      @opensource_project.destroy
      redirect_to admin_opensource_projects_path
    end

    def upcoming
      @opensource_projects = OpensourceProject.includes(:user).upcoming.order('id desc').page(params[:page]).per(10)
    end

    def undestroy
      @opensource_project.update_attribute(:deleted_at, nil)
      redirect_to(admin_opensource_projects_path)
    end

    def suggest
      @opensource_project.update_attribute(:suggested_at, Time.now)
      redirect_to(@opensource_project, notice: "Opensource project suggested.")
    end

    def unsuggest
      @opensource_project.update_attribute(:suggested_at, nil)
      redirect_to(@opensource_project, notice: "Opensource project  unsuggested.")
    end

    private

    def set_opensource_project
      @opensource_project = OpensourceProject.unscoped.find_by_slug!(params[:id])
    end
  end
end
