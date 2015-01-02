Stripe.plan :basic_monthly do |plan|
  plan.name = 'Pinpoint Basic Monthly Plan'
  plan.amount = 2900 # $29
  plan.interval = 'month'
end

Stripe.plan :basic_yearly do |plan|
  plan.name = 'Pinpoint Basic Annual Plan'
  plan.amount = 29000 # $290
  plan.interval = 'year'
end

Stripe.plan :professional_monthly do |plan|
  plan.name = 'Pinpoint Professional Monthly Plan'
  plan.amount = 9900 # $99
  plan.interval = 'month'
end

Stripe.plan :professional_yearly do |plan|
  plan.name = 'Pinpoint Professional Annual Plan'
  plan.amount = 99000 # $990
  plan.interval = 'year'
end

Stripe.plan :enterprise_monthly do |plan|
  plan.name = 'Pinpoint Enterprise Monthly Plan'
  plan.amount = 49900 # $499
  plan.interval = 'month'
end

Stripe.plan :enterprise_yearly do |plan|
  plan.name = 'Pinpoint Enterprise Annual Plan'
  plan.amount = 499000 # $4,990
  plan.interval = 'year'
end

# This file contains descriptions of all your stripe plans

# Example
# Stripe::Plans::PRIMO #=> 'primo'

# Stripe.plan :primo do |plan|
#
#   # plan name as it will appear on credit card statements
#   plan.name = 'Acme as a service PRIMO'
#
#   # amount in cents. This is 6.99
#   plan.amount = 699
#
#   # currency to use for the plan (default 'usd')
#   plan.currency = 'usd'
#
#   # interval must be either 'week', 'month' or 'year'
#   plan.interval = 'month'
#
#   # only bill once every three months (default 1)
#   plan.interval_count = 3
#
#   # number of days before charging customer's card (default 0)
#   plan.trial_period_days = 30
# end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.
