class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # -----------------------------------------------------------------------------------------------------------------
	# Associations
	# -----------------------------------------------------------------------------------------------------------------
	has_one :company_administrator
	has_one :company, through: :company_administrator, source: :company
	has_many :applications
end
