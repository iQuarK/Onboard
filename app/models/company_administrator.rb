class CompanyAdministrator < ActiveRecord::Base

	# -----------------------------------------------------------------------------------------------------------------
	# Associations
	# -----------------------------------------------------------------------------------------------------------------	
	belongs_to :company 
	belongs_to :user

	# -----------------------------------------------------------------------------------------------------------------
	# Validations
	# -----------------------------------------------------------------------------------------------------------------
	validates_presence_of :company_id, :user_id
	validates_uniqueness_of :company_id, scope: :user_id, message: "This user is already an admin of the company."

end
