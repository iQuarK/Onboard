class Job < ActiveRecord::Base
	belongs_to :company
	has_many :applications
end
