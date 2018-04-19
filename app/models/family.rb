class Family < ApplicationRecord
    belongs_to :user
    has_many :students
    has_many :registrations, through: :students
    
    #validation 
    validates_presence_of :family_name
    validates_presence_of :parent_first_name 
    validates :user_id, presence: true, numericality: { greater_than: 0, only_integer: true }
    
    #scopes
    scope :alphabetical, -> { order('family_name, parent_first_name') }
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    
    before_destroy :families_can_never_be_destroyed
    before_update :check_upcoming_registrations
    
    
    private
    
    def families_can_never_be_destroyed
      errors.add(:family,"The bond of a family can never be destroyed. #DeepQuotes")
      throw(:abort)
    end
    
    def check_upcoming_registrations
      if (self.active_changed?)
        if self.active_was == true
          self.user.update_attributes(:active => false)
          self.students.map do |this|
            this.registrations.map {|reg| reg.destroy if reg.camp.start_date >= Date.today }
            
          end 
        end 
      end
    end
    
end
