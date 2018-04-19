class Curriculum < ApplicationRecord
  # relationships
  has_many :camps

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  ratings_array = [0] + (100..3000).to_a
  validates :min_rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }
  validates :max_rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }
  validate :max_rating_greater_than_min_rating

  # scopes
  scope :alphabetical, -> { order('name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :for_rating, ->(rating) { where("min_rating <= ? and max_rating >= ?", rating, rating) }

  before_destroy :cannot_destroy
  before_update :active_checker
  
  def max_rating_greater_than_min_rating
    # only testing 'greater than' in this method, so...
    return true if self.max_rating.nil? || self.min_rating.nil?
    unless self.max_rating > self.min_rating
      errors.add(:max_rating, "must be greater than the minimum rating")
    end
  end
  
  def cannot_destroy
      errors.add(:curriculum,"Records cannot be destroyes")
      throw(:abort)
  end

  def active_checker 
      counter = 0
      self.camps.map do |count|
        if count.start_date >= Date.today
          count.registrations.map do |rat|
            counter += 69
          end 
        end 
      end
      if counter > 0
        self.active = true 
      end 
  end

end
