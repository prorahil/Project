module Contexts
  module RegistrationContexts
    def create_registrations
      
      @reg1 = FactoryBot.create(:registration, student: @rahil, camp: @camp1, payment:"Dsg3kP08feKkoT", credit_card_number: 347184365400000, expiration_month: 11, expiration_year: 2018)
      @reg2 = FactoryBot.create(:registration, student: @rahil, camp: @camp2, payment:"Sfknerfe", credit_card_number: 6594610783456321, expiration_month: 10, expiration_year: 2018)
      @reg3 = FactoryBot.create(:registration, student: @jeff, camp: @camp2, credit_card_number: 4123420188433695, expiration_month: 12, expiration_year: 2018)
      @r1 = FactoryBot.build(:registration, student: @rahil, camp: @camp2, payment:"fneknfoern", credit_card_number: 5123482671254329, expiration_month: 11, expiration_year: 2020)
      @r2 = FactoryBot.build(:registration, student: @jeff, camp: @camp2, payment:"feuifberufbeirfb", credit_card_number: 30093628456218, expiration_month: 11, expiration_year: 2020)
    end 
    
    
    
    def delete_registrations
      @reg1.delete
      @reg2.delete
      @reg3.delete
    end
  
    

    
  end
end