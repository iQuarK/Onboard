class Company < ActiveRecord::Base
	has_many :company_administrators, dependent: :destroy
	has_many :administrators, through: :company_administrators, source: :user
	has_many :jobs
end
