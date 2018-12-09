module Homeland::OpensourceProject
  class OpensourceProjectsController < Homeland::OpensourceProject::ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :update, :publish, :destroy]
    before_action :set_opensource_project, only: [:edit, :update, :publish, :destroy]

    def index
      @opensource_projects = OpensourceProject.includes(:user).published.order('published_at desc, id desc').page(params[:page]).per(10)
      @hot_opensource_projects = OpensourceProject.includes(:user).published.hotest.limit(9)
    end

    def show
      @opensource_project = OpensourceProject.unscoped.find_by_slug!(params[:id])
      if @opensource_project.deleted_at.blank?
        @opensource_project.hits.incr(1)
      else
        if not can?(:publish, @opensource_project)
          redirect_to opensource_projects_path, notice: "该项目已经下架"
        else
          @opensource_project
        end
      end
    end

    def preview
      out = Homeland::Markdown.call(params[:body])
      render plain: out
    end

    def new
      authorize! :create, OpensourceProject
      @opensource_project = OpensourceProject.new
    end

    def edit
      authorize! :update, @opensource_project
    end

    def create
      authorize! :create, OpensourceProject
      @opensource_project = OpensourceProject.new(opensource_project_params)
      @opensource_project.user_id = current_user.id

      if @opensource_project.save
        redirect_to @opensource_project, notice: '提交成功，需要等待管理员审核。'
      else
        render :new
      end
    end

    def update
      authorize! :update, @opensource_project
      if @opensource_project.update(opensource_project_params)
        redirect_to @opensource_project, notice: '更新成功。'
      else
        render :edit
      end
    end

    def publish
      authorize! :publish, @opensource_project
      @opensource_project.published!
      redirect_to opensource_projects_path, notice: "审核成功。"
    end

    def destroy
      authorize! :destroy, @opensource_project
      @opensource_project.destroy
      redirect_to opensource_projects_url, notice: '删除成功。'
    end

    private
      def set_opensource_project
        @opensource_project = OpensourceProject.find_by_slug!(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def opensource_project_params
        params.require(:opensource_project).permit(:title, :slug, :body, :summary, :avatar, :license, :dev_language,
                                                   :operator_os, :doc_url, :proj_url)
      end
  end
end
