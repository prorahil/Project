require 'test_helper'

class CurriculumTest < ActiveSupport::TestCase
  # test relationships
  should have_many(:camps)

  # test validations
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).case_insensitive

  should allow_value(1000).for(:min_rating)
  should allow_value(100).for(:min_rating)
  should allow_value(2872).for(:min_rating)
  should allow_value(0).for(:min_rating)

  should_not allow_value(nil).for(:min_rating)
  should_not allow_value(3001).for(:min_rating)
  should_not allow_value(50).for(:min_rating)
  should_not allow_value(-1).for(:min_rating)
  should_not allow_value(500.50).for(:min_rating)
  should_not allow_value("bad").for(:min_rating)

  should allow_value(1000).for(:max_rating)
  should allow_value(100).for(:max_rating)
  should allow_value(2872).for(:max_rating)

  should_not allow_value(nil).for(:max_rating)
  should_not allow_value(3001).for(:max_rating)
  should_not allow_value(50).for(:max_rating)
  should_not allow_value(-1).for(:max_rating)
  should_not allow_value(500.50).for(:max_rating)
  should_not allow_value("bad").for(:max_rating)

    # test that max greater than min rating
  should "shows that max rating is greater than min rating" do
    bad = FactoryBot.build(:curriculum, name: "Bad curriculum", min_rating: 500, max_rating: 500)
    very_bad = FactoryBot.build(:curriculum, name: "Very bad curriculum", min_rating: 500, max_rating: 450)
    deny bad.valid?
    deny very_bad.valid?
  end

  context "Within context" do
    # create the objects I want with factories
    setup do 
      create_curriculums
    end
    
    # and provide a teardown method as well
    teardown do
      delete_curriculums
    end

    # test the scope 'alphabetical'
    should "shows that there are three curriculums in in alphabetical order" do
      assert_equal ["Endgame Principles", "Mastering Chess Tactics", "Smith-Morra Gambit"], Curriculum.alphabetical.all.map(&:name), "#{Curriculum.class}"
    end
    
    # test the scope 'active'
    should "shows that there are two active curriculums" do
      assert_equal 2, Curriculum.active.size
      assert_equal ["Endgame Principles", "Mastering Chess Tactics"], Curriculum.active.all.map(&:name).sort, "#{Curriculum.methods}"
    end
    
    # test the scope 'active'
    should "shows that there is one inactive curriculum" do
      assert_equal 1, Curriculum.inactive.size
      assert_equal ["Smith-Morra Gambit"], Curriculum.inactive.all.map(&:name).sort
    end

    # test the scope 'for_rating'
    should "shows that there is a working for_rating scope" do
      assert_equal 1, Curriculum.for_rating(1400).size
      assert_equal ["Mastering Chess Tactics","Smith-Morra Gambit"], Curriculum.for_rating(600).all.map(&:name).sort
    end
 
    should "test something" do
      create_locations
      create_camps
      create_users
      create_families
      
      @bruh1 = FactoryBot.create(:student, family: @f1 ,first_name: "Sania", last_name: "Fatima", date_of_birth: 10.years.ago.to_date, rating: nil, active: true)
      @temp   = FactoryBot.create(:curriculum, name: "Tester", min_rating: 700, max_rating: 1500, active: true )
      @temp1 = FactoryBot.create(:camp, curriculum: @temp, location: @north, time_slot: "am")
      @temp.update_attributes(:active => false)
      assert_equal false, @temp.active
      @temp.active = true
      
      @tactics.destroy
    end
    
    should "test this" do
      create_locations
      create_users
      create_families
      @bruh1 = FactoryBot.create(:student, family: @f1 ,first_name: "Sania", last_name: "Fatima", date_of_birth: 10.years.ago.to_date, rating: nil, active: true)
      @temp   = FactoryBot.create(:curriculum, name: "Tester", min_rating: 700, max_rating: 1500, active: true )
      @temp2 = FactoryBot.create(:camp, curriculum: @temp, location: @north, time_slot: "pm")
      @temp3 = FactoryBot.create(:registration, camp: @temp2, student: @bruh1, credit_card_number: 4727590547932105)
      @temp.update_attributes(:active => false)
      assert_equal true, @temp.active
    end
 
  end
end
