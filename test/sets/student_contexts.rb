module Contexts
  module StudentContexts
      
    def create_students
       @rahil = FactoryBot.create(:student, family: @f1 ,first_name: "Rahil", last_name: "Ahmed", date_of_birth: 10.years.ago.to_date, rating:135)
       @jeff = FactoryBot.create(:student, family: @f1 ,first_name: "Jeff", last_name: "Daniels", date_of_birth: 10.years.ago.to_date, rating:101)
    end
      
    def delete_students
       @rahil.delete 
    end
  end
end