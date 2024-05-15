class RoomsController < ApplicationController

    def new
        @room = Room.new
        @room.users << current_user
    end
    
    def create
        teacher_name = params[:room].delete(:teacher)
        teacher = Teacher.find_or_create_by(teacher: teacher_name)
        @room = Room.new(room_params)
        @room.teacher = teacher
        @room.users << current_user
        
        if @room.save
          redirect_to room_path(@room), notice: 'ルームを作成しました', method: :post
        else
          redirect_to :action => "new"
        end
    end


    
    def index
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
    
    def show
        @user = current_user
        @comment = Comment.new
        @room = Room.find_by(id: params[:id])
        if @room.nil?
            @room = Room.create
            flash[:notice] = '新しいルームが作成されました。'
        else
            if !@room.users.include?(current_user)
                @room.users << current_user
            end
        end
    
        if params[:id].present?
            @tweet = Tweet.find_by(id: params[:id])
            if @tweet
                @comments = @tweet.comments
            else
                @tweet = current_user.tweets.new
                @comments = []
            end
        else
            @tweet = current_user.tweets.new
            @comments = []
        end
        
        @tweets = Tweet.where(room_id: @room.id).all

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

    end
    

    def edit
        @tweet = Tweet.find(params[:id])
        session[:previous_url] = request.referer
        @user = current_user
    end

    def destroy
        @tweet = Tweet.find(params[:id])
        if @tweet.destroy
          redirect_to room_path(@tweet.room), notice: 'ツイートが削除されました。'
        else
          redirect_to room_path(@tweet.room), alert: 'ツイートの削除に失敗しました。'
        end
    end

    def update
        @tweet = Tweet.find(params[:id])
        if @tweet.update(tweet_params)
        redirect_to session[:previous_url]
        else
          render :edit
        end
    end

      def research
        @user = current_user
        @room = Room.new
        @room.users << current_user
        @rooms = Room.includes(:teacher).order(updated_at: :desc)
        search = params[:search]
        year = params[:year]
        semester = params[:semester]
        day_of_week = params[:day_of_week]
        period = params[:period]

          @rooms = @rooms.where("roomname LIKE ? OR teacher LIKE ?", "%#{search}%", "%#{search}%") if search != nil and search != "" and search != "選択しない" 
          @rooms = @rooms.where(year: year) if year != nil and year != "" and  year != "選択しない" 
          @rooms = @rooms.where(semester: semester) if semester != nil and semester != "" and  semester != "選択しない" 
          @rooms = @rooms.where(day_of_week: day_of_week) if day_of_week != nil and day_of_week != "" and  day_of_week != "選択しない" 
          @rooms = @rooms.where(period: period) if period != nil and period != "" and  period != "選択しない" 
      
          if @rooms.empty?
            flash.now[:alert] = "該当する講義が見つかりませんでした。新しいルームを作成して、質問しよう！"
          end
          Rails.logger.debug("検索クエリ: #{search}")
          Rails.logger.debug("検索結果: #{@rooms.inspect}")

          @rooms2 = Room.includes(:teacher)
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


      end
      

      def leave
        @room = Room.find(params[:id])
        current_user.user_rooms.find_by(room_id: @room.id).destroy
        redirect_to rooms_path, notice: 'ルームから退会しました'
      end


      def join
        @room = Room.find(params[:id])
        user_room = current_user.user_rooms.find_or_initialize_by(room_id: @room.id)
        user_room.update(active: true)
        redirect_to @room, notice: 'ルームに参加しました'
      end


    private
    def room_params
        params.require(:room).permit(:roomname, :teacher_id, :teacher, :year, :semester, :day_of_week, :period, user_ids: [])
    end
    
    
    def tweet_params
        params.require(:tweet).permit(:body)
    end
end