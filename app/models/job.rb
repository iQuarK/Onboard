class Job < ActiveRecord::Base

  # -------------------------------------------------------------------------------------------------------------------
  # Attributes
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Validations
  # -------------------------------------------------------------------------------------------------------------------

  validates_presence_of :title, :description, :location, :job_type, :company_id, :requirements, :benefits

  # -------------------------------------------------------------------------------------------------------------------
  # Associations
  # -------------------------------------------------------------------------------------------------------------------

  belongs_to :company
  has_many :applications

  # -------------------------------------------------------------------------------------------------------------------
  # Nested Attributes
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Constants
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Named Scopes
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Callbacks
  # -------------------------------------------------------------------------------------------------------------------

  after_create :send_emails

  # -------------------------------------------------------------------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------------------------------------------------------------------
  private

  def send_emails
    JobMailer.new_job(self).deliver
  end

end
