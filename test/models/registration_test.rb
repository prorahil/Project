require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  should belong_to(:camp)
  should belong_to(:student)
  
  should validate_presence_of(:camp_id)
  should validate_presence_of(:student_id)
  should validate_numericality_of(:camp_id).only_integer.is_greater_than(0)
  should validate_numericality_of(:student_id).only_integer.is_greater_than(0)
  
  context "Within context" do
    setup do 
      create_users
      create_families
      create_students
      create_curriculums
      create_active_locations
      create_camps
      create_registrations
    end
    
    teardown do
      #delete_registrations
    end
    
    should "student assigned to an inactive camp" do
      bad_assignment = FactoryBot.build(:registration, student: @rahil, camp: @camp3, credit_card_number: 3414560983, expiration_month: 11, expiration_year: 2020)
      deny bad_assignment.valid?
    end
    
    should "not allow an inactive student to assigned to a camp" do
      bad_assignment = FactoryBot.build(:registration, student: @rahil, camp: @camp3, credit_card_number: 341234567943265, expiration_month: 12, expiration_year: 2018)
      deny bad_assignment.valid?
    end
    
    should "test expiry" do
      bad_expiry = FactoryBot.build(:registration, student: @rahil, camp: @camp3, credit_card_number: 341234567943265, expiration_month: 2, expiration_year: 2018)
      bad_expiry.expiry_date
    end
    
    should "test pay" do
      create_families
      @camp689384 = FactoryBot.create(:camp, curriculum: @tactics, start_date: Date.new(2018,9,10), end_date: Date.new(2018,9,11), location: @cmu, cost:1040)
      @thiss = FactoryBot.create(:registration, student: @rahil, camp: @camp689384,  credit_card_number: 371234567890123, expiration_month: 10, expiration_year: 2020)
      @thiss.pay  
      assert_equal @thiss.payment, @thiss.payment
      @this2 = FactoryBot.create(:registration, student: @rahil, camp: @camp689384,  credit_card_number: 371234567890123, payment: "VISA", expiration_month: 10, expiration_year: 2020)
      @this2.pay
    end
    
    should "test creditcard" do
      assert_equal "Amex", @reg1.credit_card_number_check
      assert_equal "Discovery Card", @reg2.credit_card_number_check
      assert_equal "Visa Card", @reg3.credit_card_number_check
      assert_equal "Master Card", @r1.credit_card_number_check
      assert_equal "Diners Club", @r2.credit_card_number_check
    end
  end
end
