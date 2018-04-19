require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  should belong_to(:family)
  should have_many(:registrations)
  should have_many(:camps), through: :registrations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_numericality_of(:family_id)
  
  should_not allow_value("bad").for(:family_id)
  
  context "Within context" do
    setup do 
      create_users
      create_families
      create_students
      create_locations
      create_curriculums
      create_camps
      create_more_curriculums
      create_past_camps
    end
    
    teardown do
      delete_students
      delete_families
      delete_users
    end
    
    
    should "validate student name method" do
      assert_equal "Ahmed, Rahil", @rahil.name
    end
    
    should "validate student proper name method" do
      assert_equal "Rahil Ahmed", @rahil.proper_name
    end
    
    should "validate age method" do
      assert_equal 10, @rahil.age
    end
    
    should "validate age setting to zero" do
      @rah = FactoryBot.build(:student, family: @f1 ,first_name: "Sania", last_name: "Fatima", date_of_birth: 10.years.ago.to_date, rating: nil)
      @rah.rating_check
      @rah.save!
      assert_equal 0, @rah.rating
    end
    
    should "validate removing inactive" do
      @bruh = FactoryBot.create(:student, family: @f1 ,first_name: "Sania", last_name: "Fatima", date_of_birth: 10.years.ago.to_date, rating: nil, active: true)
      @d = FactoryBot.create(:registration, camp: @camp1, student: @bruh, credit_card_number: 4727590547932105)
      @e = FactoryBot.create(:registration, camp: @camp10, student: @bruh, credit_card_number: 4727590547932105)
      @bruh.update_attributes(:active => false)
    end
    
    should "validate removing students" do
      @bruh1 = FactoryBot.create(:student, family: @f1 ,first_name: "Sania", last_name: "Fatima", date_of_birth: 10.years.ago.to_date, rating: nil, active: true)
      @d1 = FactoryBot.create(:registration, camp: @camp1, student: @bruh1, credit_card_number: 4727590547932105)
      @e1 = FactoryBot.create(:registration, camp: @camp10, student: @bruh1, credit_card_number: 4727590547932105)
      
      @bruh1.destroy
      assert_equal false, @bruh1.destroyed?
      
      @bruh2 = FactoryBot.create(:student, family: @f1 ,first_name: "Sania", last_name: "Fatima", date_of_birth: 10.years.ago.to_date, rating: nil, active: true)
      @d2 = FactoryBot.create(:registration, camp: @camp1, student: @bruh2, credit_card_number: 4727590547932105)
      #@e2 = FactoryBot.create(:registration, camp: @camp10, student: @bruh2, credit_card_number: 4727590547932105)
      @bruh2.destroy
      assert_equal true, @bruh2.destroyed?
    end
    
  end
end
