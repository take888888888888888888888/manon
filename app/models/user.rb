class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :tweets, dependent: :destroy

  has_many :user_rooms

  has_many :agrees, dependent: :destroy
  has_many :agreed_tweets, through: :agrees, source: :tweet

  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :agrees, source: :tweet

  has_many :resolves, dependent: :destroy
  has_many :resolved_tweets, through: :resolves, source: :tweet

  has_many :comments, dependent: :destroy

  
  validates :profile, length: { maximum: 200 } 

  def unresolved_tweets
    tweets.where(resolved: false)
  end

  def already_liked?(tweet)
    self.likes.exists?(tweet_id: tweet.id)
  end

  def already_agreed?(tweet)
    self.agrees.exists?(tweet_id: tweet.id)
  end

  def already_resolved?(tweet)
    self.resolves.exists?(tweet_id: tweet.id)
  end

end
