class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # -----------------------------------------------------------------------------------------------------------------
	# Associations
	# -----------------------------------------------------------------------------------------------------------------
	has_many :company_administrators
	has_many :companies, through: :company_administrators, source: :company
end
