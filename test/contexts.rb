# require needed files
require './test/sets/curriculum_contexts'
require './test/sets/instructor_contexts'
require './test/sets/camp_contexts'
require './test/sets/camp_instructor_contexts'
require './test/sets/location_contexts'
require './test/sets/student_contexts'
require './test/sets/user_contexts.rb'
require './test/sets/family_contexts.rb'
require './test/sets/registration_contexts.rb'


module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::CurriculumContexts
  include Contexts::InstructorContexts
  include Contexts::CampContexts
  include Contexts::CampInstructorContexts
  include Contexts::LocationContexts
  include Contexts::UserContexts
  include Contexts::FamilyContexts
  include Contexts::StudentContexts
  include Contexts::RegistrationContexts

  def create_cuke_contexts
    create_curriculums
    create_active_locations
    create_instructors
    create_camps
    create_camp_instructors
    create_more_curriculums
    create_more_instructors
    create_past_camps
    create_upcoming_camps
    create_more_camp_instructors
    create_users
    create_families
    create_students
  end

end