require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_one(:family)
  
  should allow_value("443-696-3269").for(:phone)
  
  context "Within context" do
    setup do 
      create_users
    end
    
    teardown do
      delete_users
    end
    
    should "require password for new users" do
      user69 = FactoryBot.build(:user, username: "illuminati", password: nil)
      deny user69.valid?
    end
    
  end
end
