class Room < ApplicationRecord
        validates :roomname, presence: true, uniqueness: true
        
        belongs_to :teacher
        has_many :user_rooms
        has_many :users, through: :user_rooms
        has_many :tweets
        accepts_nested_attributes_for :user_rooms

    end
