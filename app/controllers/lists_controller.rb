class ListsController < ApplicationController

  def index
    @lists = List.all
  end

  def show
    @list = current_user.lists.find(params[:id])
    @tasks = @list.recent_tasks
  end

  def new
    @list = current_user.lists.new
  end

  def edit
    @list = current_user.lists.find(params[:id])
  end

  def create
    @list = current_user.lists.new(params[:list])
    redirect_to @list, notice => 'List was successfully created.' if @list.save
  end

  def update
    @list = List.find(params[:id])
    redirect_to @list, notice => 'List was successfully updated.' if @list.update_attributes(params[:list])
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    render :text => nil
  end
end
