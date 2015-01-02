class Company < ActiveRecord::Base

  # -------------------------------------------------------------------------------------------------------------------
  # Attributes
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Validations
  # -------------------------------------------------------------------------------------------------------------------

  validates_presence_of :name, :description, :industry, :location
  validates :subdomain, presence: true, uniqueness: true, subdomain: true

  # -------------------------------------------------------------------------------------------------------------------
  # Associations
  # -------------------------------------------------------------------------------------------------------------------
  has_many :company_administrators, dependent: :destroy
  has_many :administrators, through: :company_administrators, source: :user
  has_many :jobs

  # -------------------------------------------------------------------------------------------------------------------
  # Nested Attributes
  # -------------------------------------------------------------------------------------------------------------------


  # -----------------------------------------------------------------------------------------------------------------
  # Static Arrays of Data
  # -----------------------------------------------------------------------------------------------------------------
  INDUSTRY = ["Agriculture", "Accounting", "Advertising", "Aerospace", "Apparel & Accessories", "Automotive", "Broadcasting", "Biotechnology", "Call Centres", "Consulting", "Cosmetics", "Defense", "Education", "Electronics", "Energy", "Entertainment & Leisure", "Financial Services", "Food & Beverage", "Healthcare", "Legal", "Manufacturing", "Music / Film", "Pharmaceuticals", "Publishing", "Real Estate", "Retail & Wholesale", "Software", "Sports", "Technology", "Telecommunications", "Transporation", "Venture Capital"]
  NUM_EMPLOYEES = ["1 - 10", "11 - 25", "26 - 50", "51 - 100", "101 - 200", "200 - 1,000", "1,000+"]


  # -------------------------------------------------------------------------------------------------------------------
  # Constants
  # -------------------------------------------------------------------------------------------------------------------

  # 14 Day length of trial period
  TRIAL_PERIOD = 14

  # -------------------------------------------------------------------------------------------------------------------
  # Named Scopes
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Callbacks
  # -------------------------------------------------------------------------------------------------------------------

  before_create :set_plan

  # -------------------------------------------------------------------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------------------------------------------------------------------
  def has_jobs?
    self.jobs.any?
  end


  # -------------------------------------------------------------------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------------------------------------------------------------------
  private

  def set_plan
    self.plan ||= 'trial'
  end

end
