class ResolvesController < ApplicationController

    def create
        resolve = current_user.resolves.create(tweet_id: params[:tweet_id]) 
        redirect_back(fallback_location: root_path)
    end
    
    def destroy
        resolve = Resolve.find_by(tweet_id: params[:tweet_id], user_id: current_user.id)
        resolve.destroy
        redirect_back(fallback_location: root_path)
    end
end
