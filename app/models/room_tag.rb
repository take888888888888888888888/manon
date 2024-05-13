class RoomTag < ApplicationRecord
    #validates :name, presence: true
    #Tagsテーブルから中間テーブルに対する関連付け
    #has_many :room_tag_relations, dependent: :destroy
    #Tagsテーブルから中間テーブルを介してArticleテーブルへの関連付け
    #has_many :rooms, through: :room_tag_relations, dependent: :destroy
end
