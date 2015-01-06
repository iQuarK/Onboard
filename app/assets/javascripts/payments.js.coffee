jQuery ->

  # Stripe publishable key set using stripe-rails gem (see head)
  subscription.setupForm()

subscription =

  setupForm: ->
    $('#card-details-form').submit ->
      $('input[type=submit]').prop('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        return false
      else
        return true

  processCard: ->
    card =
      number: $('#card_number').val(),
      cvc: $('#card_code').val(),
      expMonth: $('#card_month').val(),
      expYear: $('#card_year').val()
    Stripe.createToken(card, subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#stripe_card_token').val(response.id)
      $('#card-details-form')[0].submit()
    else
      $('#stripe-error').text(response.error.message).show()
      $('input[type=submit]').prop('disabled', false)