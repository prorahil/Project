require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  should belong_to(:user)
  #should have_many(:students)
  #should have_many(:registrations).through(:students)
  should validate_presence_of(:family_name)
  should validate_presence_of(:parent_first_name)
  
  context "Within context" do
    setup do 
      create_users
      create_families
      create_locations
      create_curriculums
      create_camps
      create_more_curriculums
      create_past_camps
    end
    
    # teardown do
    #   delete_families
    #   delete_users
    #   delete_locations
    # end
    
    should "sort alphabetically" do
      assert_equal %w[Ahmed IDK], Family.alphabetical.all.map(&:family_name)
    end
    
    should "show families are indestructable" do
      deny @f1.destroy
    end
    
    should "show that there is one inactive family" do
      assert_equal %w[IDK], Family.inactive.all.map(&:family_name).sort
    end
    
    should "remove upcoming registrations when family is made inactive" do
      @k = FactoryBot.create(:family, family_name: "Rafiq", user: @user1, parent_first_name: "Rafiq", active: true)
      @c = FactoryBot.create(:student, family: @k ,first_name: "Preetha", last_name: "Gopinath", date_of_birth: 10.years.ago.to_date, rating:500, active: true)
      @d = FactoryBot.create(:registration, camp: @camp1, student: @c, credit_card_number: 4727590547932105)
      @e = FactoryBot.create(:registration, camp: @camp10, student: @c, credit_card_number: 4727590547932105)
      assert_equal 2, @k.registrations.count
      @k.update_attributes(:active => false)
      assert_equal 1, @k.registrations.count
      
    end
    
  end
end