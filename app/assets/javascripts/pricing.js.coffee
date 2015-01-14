jQuery ->

  # Change the plan amounts with the toggle
  $('input[name="interval"').on 'change', () ->
    interval = $(this).val()
    if interval == "monthly"
      $('.l-pricing').removeClass('yearly').addClass('monthly')
    else if interval == "yearly"
      $('.l-pricing').removeClass('monthly').addClass('yearly')



