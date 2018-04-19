class User < ApplicationRecord
    has_one :instructor 
    has_one :family
    
    has_secure_password
    
    ROLES = ["admin", "parent", "instructor"]
    
    validates_presence_of :username, :email
    validates :username, uniqueness: { case_sensitive: false }
    validates :email, uniqueness: { case_sensitive: false }
    validates :email, presence: true, uniqueness: { case_sensitive: false}, format: { with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format" }
    validates :phone, format: { with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only", allow_blank: true }
    validates_length_of :password, :minimum => 4
    validates_presence_of :password, on: :create 
    validates_presence_of :password_confirmation, on: :create
    validates_confirmation_of :password, message: "does not match"
    validates :role, inclusion: { in: ROLES.map{|role| role }, message: "not a valid role"}
    
    
    before_save :reformat_phone
    
    
    private
    def reformat_phone
        phone = self.phone.to_s  # change to string in case input as all numbers 
        phone.gsub!(/[^0-9]/,"") # strip all non-digits
        self.phone = phone       # reset self.phone to new string
    end
    
end
