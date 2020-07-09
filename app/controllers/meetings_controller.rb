class MeetingsController < ApplicationController


  def index
    @meetings = Meeting.all.order(updated_at: :desc)
  end

  def show

  end
  def new
    @meeting = Meeting.new
  end
  
  def create
    @meeting = Meeting.new(creat_params)
    @meeting.user_id = current_user.id
    if @meeting.save # 保存失敗して
      redirect_to meetings_path
    else
      render :new # failed_pathに遷移する
    end
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def update
    @meeting = Meeting.find(params[:id])
    
    if @meeting.update(creat_params)
      @meetings = Meeting.all.order(updated_at: :desc)
    else
    end
  end

  def destroy

  end

  private
    def creat_params
      params.require(:meeting).permit(:area, :date_time, :bar, :url, :explain)
    end


    def user_signed_in
      redirect_to new_user_session_path unless user_signed_in?
    end
end
