class TasksController < ApplicationController
  
  before_filter :authenticate
  
  def list_ordered
    @tasks = current_user.tasks.recent
    render :layout => false
  end

  def show
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  def new
    @task = current_user.tasks.new

    respond_to do |format|
      format.html #{ render :layout => false }
      format.json { render json: @task }
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def create
    @task = current_user.tasks.new(params[:task])
    
      if @task.save
        @list = @tasks = @task.list
        @tasks = @list.recent_tasks
        render 'lists/show', :layout => false 
      else
        render :status => 400
      end
  end

  def update
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { render :text => :none }
        format.json { head :ok }
      else
        format.html { render :text => :none }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { render :text => :none }
      format.json { head :ok }
    end
  end
end