class AgreesController < ApplicationController

    def create
        agree = current_user.agrees.create(tweet_id: params[:tweet_id]) 
        redirect_back(fallback_location: root_path)
    end
    
    def destroy
        agree = Agree.find_by(tweet_id: params[:tweet_id], user_id: current_user.id)
        agree.destroy
        redirect_back(fallback_location: root_path)
    end

end
