class Devise::RegistrationsController < DeviseController
    before_action :authenticate_user!
    before_action :set_rooms, only: [:edit, :update]
  
    def edit
        @user = current_user
        @rooms = Room.includes(:teacher)
        .where(id: current_user.user_rooms.pluck(:room_id))
        .order(Arel.sql("CASE WHEN day_of_week = '月' THEN 0 
                          WHEN day_of_week = '火' THEN 1 
                          WHEN day_of_week = '水' THEN 2 
                          WHEN day_of_week = '木' THEN 3 
                          WHEN day_of_week = '金' THEN 4 
                          ELSE 5 END"))
        .order(Arel.sql("CASE WHEN period = '1限' THEN 0 
                          WHEN period = '2限' THEN 1 
                          WHEN period = '3限' THEN 2 
                          WHEN period = '4限' THEN 3 
                          WHEN period = '5限' THEN 4 
                          WHEN period = '6限' THEN 5 
                          ELSE 6 END"))
        @room = Room.new
        @room.users << current_user
        search = params[:search]
        year = params[:year]
        semester = params[:semester]
        day_of_week = params[:day_of_week]
        period = params[:period]
    end
  
    private
  
    def room_params
        params.require(:room).permit(:roomname, :teacher_id, :teacher, :year, :semester, :day_of_week, :period, user_ids: [])
    end
  end