class MeetingsController < ApplicationController


  def index
    @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
    @sum_meetings = @meetings.length
  end

  def show
    @meeting = Meeting.find(params[:id])
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
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
      @sum_meetings = @meetings.length
    else
    end
  end

  def destroy
    @meeting = Meeting.find(params[:id]).page(params[:page]).per(10)
    if @meeting.destroy
      @meetings = Meeting.all.order(updated_at: :desc)
      @sum_meetings = @meetings.length
      flash.now[:success] = "削除に成功しました"
    else
      flash.now[:danger] = "削除に失敗しました"
    end
  end

  def join

  end

  private
    def creat_params
      params.require(:meeting).permit(:area, :date_time, :bar, :url, :explain, :image)
    end


    def user_signed_in
      redirect_to new_user_session_path unless user_signed_in?
    end
end
