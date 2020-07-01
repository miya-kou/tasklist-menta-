class TasksController < ApplicationController
  before_action :require_user_logged_in
  
  def index
  @tasks = Task.where(user_id: session[:user_id])
  end
  
  def show
  @task = Task.find(params[:id])
  end
  
  def new
  @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    @task.user_id = session[:user_id]
    if @task.save
      flash[:success] = 'タスクが投稿されました'
      redirect_to @task
    else
      flash[:danger] = 'タスクが投稿されません'
      render :new
    end
  end
  
  def edit
  @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
    flash[:success] = 'タスクが編集されました'
    redirect_to @task
    else
    flash.now[:danger] = 'タスクが編集されませんでした'
    render :new
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'タスクが削除されました'
    redirect_to tasks_path
  end 
end

  private

  def task_params
    params.require(:task).permit(:content)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
