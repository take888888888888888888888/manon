class Tweet < ApplicationRecord

    belongs_to :user
    belongs_to :room

    has_many :agrees, dependent: :destroy
    has_many :agreed_users, through: :agrees, source: :user
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user
    has_many :resolves, dependent: :destroy
    has_many :resolved_users, through: :resolves, source: :user
    has_many :comments, dependent: :destroy
    #validates :name, presence: true 
    #has_many :tweet_tag_relations, dependent: :destroy
    #has_many :tags, through: :tweet_tag_relations, dependent: :destroy
    
    scope :unresolved, -> { where(resolved: false) }

    
end
