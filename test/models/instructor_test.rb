require 'test_helper'

class InstructorTest < ActiveSupport::TestCase
  # test relationships
  should have_many(:camp_instructors)
  should have_many(:camps).through(:camp_instructors)

  # test validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  # should validate_presence_of(:email)
  # should validate_uniqueness_of(:email).case_insensitive

  
  # set up context
  context "Within context" do
    setup do
      create_users
      create_instructors
    end
    
    teardown do
     # delete_instructors
    end

    should "show that there are three instructors in alphabetical order" do
      assert_equal ["Alex", "Mark", "Rachel"], Instructor.alphabetical.all.map(&:first_name)
    end

    should "show that there are two active instructors" do
      assert_equal 2, Instructor.active.size
      assert_equal ["Alex", "Mark"], Instructor.active.all.map(&:first_name).sort
    end
    
    should "show that there is one inactive instructor" do
      assert_equal 1, Instructor.inactive.size
      assert_equal ["Rachel"], Instructor.inactive.all.map(&:first_name).sort
    end

    should "show that there are two instructors needing bios" do
      assert_equal 2, Instructor.needs_bio.size
      assert_equal ["Alex", "Rachel"], Instructor.needs_bio.all.map(&:first_name).sort
    end

    should "show that name method works" do
      assert_equal "Heimann, Mark", @mark.name
      assert_equal "Heimann, Alex", @alex.name
    end
    
    should "show that proper_name method works" do
      assert_equal "Mark Heimann", @mark.proper_name
      assert_equal "Alex Heimann", @alex.proper_name
    end

    # test the callback is working 'reformat_phone'


    should "have a class method to give array of instructors for a given camp" do
      # create additional contexts that are needed
      create_curriculums
      create_active_locations
      create_camps
      create_camp_instructors
      assert_equal ["Alex", "Mark"], Instructor.for_camp(@camp1).map(&:first_name).sort
      assert_equal ["Mark"], Instructor.for_camp(@camp4).map(&:first_name).sort
      # remove those additional contexts
      delete_camp_instructors
      delete_curriculums
      delete_active_locations
      delete_camps
    end
    
    should "test a function" do
      @tt = FactoryBot.create(:user, username: "rko", role: "parent", email: "ahmed@qatar.cmu.edu", password: "1234", password_confirmation: "1234", phone: "442-369-4000")
      @t1 = FactoryBot.create(:instructor, first_name: "Rhl", active: false, user: @tt)
      @t1.if_user_is_inactive_deactivate
    end
    
    should "test destroy thing" do
      @tt = FactoryBot.create(:user, username: "rko", role: "parent", email: "hmed@qatar.cmu.edu", password: "1234", password_confirmation: "1234", phone: "442-369-4000")
      @ttt = FactoryBot.create(:instructor, first_name: "Rhlahmd", active: false, user: @tt)
      @ttt.destroy
    end
    
    should "test destroy more" do
      create_curriculums
      create_more_curriculums
      create_locations
      create_past_camps
      
      @t2 = FactoryBot.create(:user, username: "rkoo", role: "parent", email: "med@qatar.cmu.edu", password: "1234", password_confirmation: "1234", phone: "442-369-4000")
      @tt2 = FactoryBot.create(:instructor, first_name: "Rhlahmd", active: true, user: @t2)
      @c1 = FactoryBot.create(:camp_instructor, instructor: @tt2, camp: @camp10)
      @tt2.destroy
    end

  end
end
