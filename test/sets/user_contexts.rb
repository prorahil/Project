module Contexts
  module UserContexts
      
     def create_users
        @user1 = FactoryBot.create(:user, username: "rahmed", role: "parent",email: "rahmed@qatar.cmu.edu", password: "1234", password_confirmation: "1234", phone: "442-369-4000", active: true)
        @user2 = FactoryBot.create(:user, username: "preethag", role: "instructor",email: "preethag@qatar.cmu.edu", password: "12345", password_confirmation: "12345", phone: "442-371-4078")
     end
      
      def delete_users
        @user1.delete
        @user2.delete
      end
  end
end