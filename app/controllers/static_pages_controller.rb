class StaticPagesController < ApplicationController



	def home
		# Use the alternative marketing layout for the front-end
		render layout: "marketing"
	end

	def about
		# Use the alternative marketing layout for the front-end
		render layout: "marketing"
	end

end
