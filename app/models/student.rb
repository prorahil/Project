class Student < ApplicationRecord
    belongs_to :family
    has_many :registrations
    has_many :camps, through: :registrations
    
    validates_presence_of :first_name, :last_name
    validates :family_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates_date :date_of_birth, allow_blank: true, :before => lambda { Date.today }, :before_message => "cannot be in the future", on:  :create
    ratings_array = (0..3000).to_a
    validates :rating, numericality: { only_integer: true, allow_blank: true }, inclusion: { in: ratings_array, allow_blank: true }

    scope :alphabetical, -> { order('last_name, first_name') }
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :below_rating, -> (ceiling) { where("rating < ?", ceiling) }
    scope :at_or_above_rating, -> (floor) { where(rating >= ?", floor) }
    
    def name
      last_name + ", " + first_name 
    end
    
    def proper_name
      first_name + " " + last_name 
    end
    
    def age
      if date_of_birth.blank?
          return nil
      else
          now = Time.now.utc.to_date
          now.year - self.date_of_birth.year - ((now.month > self.date_of_birth.month || (now.month == self.date_of_birth.month && now.day >= self.date_of_birth.day)) ? 0 : 1) 
      end
    end

    before_save :rating_check
    before_update :remove_reg_inactive
    before_destroy :destroyable_student_check
    
    
    def remove_reg_inactive
        if self.active == false
          if !self.registrations.empty?
              self.registrations.map{|jeff| jeff.destroy if (jeff.camp.start_date) >= Date.current} 
            
          end
        end
    end
    
    def rating_check
        if (self.rating == nil)
          self.rating = 0
        end
    end

    def destroyable_student_check
        flag = 1 
        self.registrations.map do |jeff|
            if Date.today > jeff.camp.end_date
                flag = 0
            end 
        end 
        
        if flag == 0
            self.active = false
            errors.add(:base,"student is undestoyable because it has been registered for a past camp")
            throw(:abort)
        else
            self.registrations.map {|reg| reg.destroy if reg.camp.start_date >= Date.today}
        end 
    end 
    
end

