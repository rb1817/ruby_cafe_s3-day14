class Daum < ApplicationRecord
    has_many :memberships
    has_many :users, through: :memberships
    has_many :posts
    
    def is_member?(user)#매게변수
        self.users.include? (user)
    end
end
