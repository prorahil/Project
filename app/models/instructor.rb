class Instructor < ApplicationRecord
  # relationships
  has_many :camp_instructors
  has_many :camps, through: :camp_instructors
  belongs_to :user

  # validations
  validates_presence_of :first_name, :last_name
  # validates :email, presence: true, uniqueness: { case_sensitive: false}, format: { with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format" }
  # validates :phone, format: { with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only", allow_blank: true }


  # scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :needs_bio, -> { where('bio IS NULL') }
  # scope :needs_bio, -> { where(bio: nil) }  # this also works...

  # class methods
  def self.for_camp(camp)
    # the 'instructive way'... (which I told you if you asked me for help)
    CampInstructor.where(camp_id: camp.id).map{ |ci| ci.instructor }
    # the easy way... 
    # camp.instructors
  end

  # callbacks
  before_update :if_user_is_inactive_deactivate
  before_destroy :check_if_this_instructor_taught_past_camps

  # instance methods
  def name
    last_name + ", " + first_name
  end
  
  def proper_name
    first_name + " " + last_name
  end

  def if_user_is_inactive_deactivate
    if !self.active
      self.user.active = false 
    end
  end 
  
  def check_if_this_instructor_taught_past_camps
    #unless self.camps.past.empty?
    x = 0
    self.camps.each {|c| x += 1 if c.end_date < Date.today }
    if x != 0 
      errors.add(:base, "Instructor has taught past camps")
    else
      self.user.active = false
      self.camp_instructors.select{|ci| ci.camp.start_date >= Date.current}.each{|ci| ci.destroy}
      self.user.destroy
    end
  end

end
