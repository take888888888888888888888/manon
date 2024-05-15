class UsersController < ApplicationController
    def edit
      @user = User.find(params[:id]) 
    end

    def leave
        room = Room.find(params[:room_id])
        current_user.rooms.delete(room)
        redirect_to leave_room_room_path, notice: 'ルームから退会しました。'
    end

    def show
      
    end

end