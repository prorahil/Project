module Contexts
  module FamilyContexts
      
     def create_families
        @f1 = FactoryBot.create(:family, family_name: "Ahmed", user: @user1, parent_first_name: "Imtiaz", active: true)
        @f2 = FactoryBot.create(:family, family_name: "IDK", user: @user1, parent_first_name: "Noidea", active: false)
     end
      
     def delete_families
       @f1.delete
       @f2.delete
       
     end
  end
end