module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)

    base_title = "Pinpoint"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # Formats LinkedIn Dates into something readable
  def linkedin_date(month)
  	case month
  		when 1
  			month = "January"
  		when 2
  			month = "February"
  		when 3 
  			month = "March"
  		when 4
  			month = "April"
  		when 5
  			month = "May"
  		when 6
  			month = "June"
  		when 7
  			month = "July"
  		when 8
  			month = "August"
  		when 9
  			month = "September"
  		when 10
  			month = "October"
  		when 11
  			month = "November"
  		when 12
  			month = "December"
  		else
  			month = ""
  	end
  	return month
  end

end
