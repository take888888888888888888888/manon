class TweetsController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create]
    before_action :set_rooms, only: [:new]

    def index
        @tweets = Tweet.all
    end

    
    def new
        @user = current_user 
        @room = Room.new
        @room.users << current_user
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
        @rooms_all = Room.all
        @comment = Comment.new
        @comment = Comment.new

      
        if params[:id].present?
          @tweet = Tweet.find(params[:id])
          @comments = tweet.comments
          @unresolved_tweets = @user.tweets.where(resolved: false)
        else
          @tweet = current_user.tweets.new
          @comments = []  
          @tweets = Tweet.all
        end
    end
      

    def new2
      @user = current_user 
      @room = Room.new
      @room.users << current_user
      @rooms = Room.includes(:teacher).where(id: current_user.user_rooms.pluck(:room_id)).order(updated_at: :desc)
      @rooms_all = Room.all
      @comment = Comment.new
      @comment = Comment.new

    
      if params[:id].present?
        @tweet = Tweet.find(params[:id])
        @comments = tweet.comments
        @unresolved_tweets = @user.tweets.where(resolved: false)
      else
        @tweet = current_user.tweets.new
        @comments = []  
        @tweets = Tweet.all
      end
  end
      
  def new3
    @user = current_user 
    @room = Room.new
    @room.users << current_user
    @rooms = Room.includes(:teacher).where(id: current_user.user_rooms.pluck(:room_id)).order(updated_at: :desc)
    @rooms_all = Room.all
    @comment = Comment.new
    @comment = Comment.new

  
    if params[:id].present?
      @tweet = Tweet.find(params[:id])
      @comments = tweet.comments
      @unresolved_tweets = @user.tweets.where(resolved: false)
    else
      @tweet = current_user.tweets.new
      @comments = []  
      @tweets = Tweet.all
    end
end

    def create
        @room = Room.find_by(id: params[:room_id])
        @tweet = current_user.tweets.build(tweet_params)
        @tweet.room_id = params[:room_id]
        tweet = Tweet.new(tweet_params)
        tweet.user_id = current_user.id

        if tweet.save!
          redirect_to room_path(params[:tweet][:room_id]), notice: 'ツイートが作成されました。'
        else
          redirect_to room_path(params[:tweet][:room_id]), alert: 'ツイートの作成に失敗しました。'
        end

        if @tweet.save
           redirect_to room_path(@room.id)
        end
    end

    def show
        @tweet = Tweet.find(params[:id])
        @comments = @tweet.comments
        @comment = Comment.new
        @user = current_user 
        @tweets = Tweet.all
        @room = Room.new
        @room.users << current_user
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
        @rooms_all = Room.all
    end


    def edit
        @tweet = Tweet.find(params[:id])
        session[:previous_url] = request.referer
        @rooms = Room.includes(:teacher).where(id: current_user.user_rooms.pluck(:room_id)).order(updated_at: :desc)
        @user = current_user 
    end

    def destroy
        tweet = Tweet.find(params[:id])
        @room = tweet.room
        tweet.destroy
        redirect_to action: :new
    end

    def update
        tweet = Tweet.find(params[:id])
        @tweet = Tweet.find(params[:id])
        @room = tweet.room

        if tweet.update(tweet_params)
            redirect_to :action => "new", :id => tweet.id
          else
            redirect_to :action => "new"
          end
    end

    def update2
        tweet = Tweet.find(params[:id])
        @tweet = Tweet.find(params[:id])
        @room = tweet.room

        if tweet.update(tweet_params)
            redirect_to session[:previous_url]
        else
            redirect_to :action => "new"
        end
    end

  
     private
      def room_params
        params.require(:room).permit(:roomname, :teacher_id, :teacher, :year, :semester, :day_of_week, :period, user_ids: [])
      end

      def tweet_params
        params.require(:tweet).permit(:body, :room_id)
      end

      def set_rooms
        @rooms = Room.all
      end

    end
