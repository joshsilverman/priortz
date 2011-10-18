class TasksController < ApplicationController
  
  before_filter :authenticate

  def index
    @tasks = current_user.tasks.all.sort_by { |t| 10000 - t.score }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end
  
  def list_ordered
    @tasks = current_user.tasks.all.sort_by { |t| 10000 - t.score }
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
    @tasks = current_user.tasks.all.sort_by { |t| 10000 - t.score }
    
    respond_to do |format|
      if @task.save
        format.html { render :new, :layout => false }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
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