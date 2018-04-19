class Registration < ApplicationRecord
    require 'base64'
    attr_accessor :credit_card_number, :expiration_year, :expiration_month
    
    belongs_to :camp
    belongs_to :student
    
    validates :camp_id, presence: true, numericality: { greater_than: 0, only_integer: true }
    validates :student_id, presence: true, numericality: { greater_than: 0, only_integer: true }
    validates :credit_card_number,  format: { with: /\A(?:(4[0-9]{12}(?:[0-9]{3})?)|(5[1-5][0-9]{14})|(6(?:011|5[0-9][0-9])[0-9]{12})|(3[47][0-9]{13})|(3(?:0[0-5]|[68][0-9])[0-9]{11}))\z/}
    validate :student_is_active_in_system
    validate :camp_is_active_in_system
    validate :expiry_date
    #validate :rating 
    
    scope :alphabetical, -> { order('last_name', 'first_name') }
    scope :for_camp, ->(camp_id) { where(camp_id: camp_id) }
    
    
    
    def pay
        if self.payment == nil
            self.payment = Base64.encode64("camp: #{self.camp_id}; student: #{self.student_id}; amount_paid: #{self.camp.cost}; card: #{self.credit_card_number_check} ****<#{self.credit_card_number.to_s.last(4)}>")
            return self.payment
        else 
            false 
        end 
    end 
    
    
    
    def student_is_active_in_system
        if self.student != nil
            if self.student.active == false
            end
        end 
    end

    def camp_is_active_in_system
        if self.camp != nil
            if self.camp.active == false
                errors.add(:camp,"is not active") 
            end 
        end 
    end
    
  
    def expiry_date
        if self.expiration_month != nil and self.expiration_year != nil
            if self.expiration_month >= Date.today.strftime("%m").to_i and self.expiration_year >= Date.today.strftime("%Y").to_i
    
            else 
                errors.add(:base,"Expiry date is invalid")
                
            end
        end 
    end 
    
    # additional method to get the type of credit card
     def credit_card_number_check 
        if self.credit_card_number != nil
            if self.credit_card_number.to_s.match(/^4/) and (self.credit_card_number.to_s.length == 16 or self.credit_card_number.to_s.length == 13)
              "Visa Card"
            elsif self.credit_card_number.to_s.match(/^5[1-5]/) and (self.credit_card_number.to_s.length == 16)
              "Master Card"
            elsif self.credit_card_number.to_s.match(/^6011|65/ ) and (self.credit_card_number.to_s.length == 16)
              "Discovery Card"
            elsif self.credit_card_number.to_s.match(/^30[0-5]/) and (self.credit_card_number.to_s.length == 14)
              "Diners Club"
            elsif self.credit_card_number.to_s.match(/^3[47]/) and (self.credit_card_number.to_s.length == 15)
              "Amex"
            
            end 
        end 
     end
  
  
end