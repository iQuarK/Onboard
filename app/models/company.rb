class Company < ActiveRecord::Base

  # -------------------------------------------------------------------------------------------------------------------
  # Attributes
  # -------------------------------------------------------------------------------------------------------------------
  attr_accessor :stripe_card_token


  # -------------------------------------------------------------------------------------------------------------------
  # Validations
  # -------------------------------------------------------------------------------------------------------------------

  validates_presence_of :name, :description, :industry, :location
  validates :subdomain, presence: true, uniqueness: true, subdomain: true

  # -------------------------------------------------------------------------------------------------------------------
  # Associations
  # -------------------------------------------------------------------------------------------------------------------
  has_many :company_administrators, dependent: :destroy
  has_many :administrators, through: :company_administrators, source: :user
  has_many :jobs

  # -------------------------------------------------------------------------------------------------------------------
  # Nested Attributes
  # -------------------------------------------------------------------------------------------------------------------


  # -----------------------------------------------------------------------------------------------------------------
  # Static Arrays of Data
  # -----------------------------------------------------------------------------------------------------------------
  INDUSTRY = ["Agriculture", "Accounting", "Advertising", "Aerospace", "Apparel & Accessories", "Automotive", "Broadcasting", "Biotechnology", "Call Centres", "Consulting", "Cosmetics", "Defense", "Education", "Electronics", "Energy", "Entertainment & Leisure", "Financial Services", "Food & Beverage", "Healthcare", "Legal", "Manufacturing", "Music / Film", "Pharmaceuticals", "Publishing", "Real Estate", "Retail & Wholesale", "Software", "Sports", "Technology", "Telecommunications", "Transporation", "Venture Capital"]
  NUM_EMPLOYEES = ["1 - 10", "11 - 25", "26 - 50", "51 - 100", "101 - 200", "200 - 1,000", "1,000+"]


  # -------------------------------------------------------------------------------------------------------------------
  # Constants
  # -------------------------------------------------------------------------------------------------------------------

  # 14 Day length of trial period
  TRIAL_PERIOD = 14

  PLANS = {
    basic_monthly: { index: 1, type: "Basic", name: "Basic Monthly", price: 29, interval: "month" },
    basic_yearly: { index: 2, type: "Basic", name: "Basic Yearly", price: 290, interval: "year" },
    professional_monthly: { index: 3, type: "Professional", name: "Professional Monthly", price: 99, interval: "month" },
    professional_yearly: { index: 4, type: "Professional", name: "Professional Yearly", price: 990, interval: "year" },
    enterprise_monthly: { index: 5, type: "Enterprise", name: "Enterprise Monthly", price: 499, interval: "month" },
    enterprise_yearly: { index: 6, type: "Enterprise", name: "Enterprise Yearly", price: 4990, interval: "year" },
  }

  # -------------------------------------------------------------------------------------------------------------------
  # Named Scopes
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Callbacks
  # -------------------------------------------------------------------------------------------------------------------

  before_create :set_plan

  # -------------------------------------------------------------------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------------------------------------------------------------------
  def on_trial?
    plan_id == "trial"
  end

  def expired_subscription?
    expired == true
  end

  def active_subscription?
    expired == false
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Create or Update Stripe subscription
  # -------------------------------------------------------------------------------------------------------------------
  def save_with_payment(email)
    if valid?
      if stripe_customer_id.blank? # New to stripe
        if stripe_card_token.blank?
          raise "Stripe token not present. Can't create account."
        end
        trial_end_timestamp = (created_at + 2.week).to_i
        customer = Stripe::Customer.create(
          email: email,
          description: name,
          plan: plan_id,
          card: stripe_card_token,
          trial_end: trial_end_timestamp
        )
      else
        customer = Stripe::Customer.retrieve(stripe_customer_id)
        if stripe_card_token.present?
          customer.card = stripe_token
        end
        customer.email = email
        customer.description = name
        customer.save
      end
      self.stripe_customer_id = customer.id
      # self.last_4_digits = customer.cards.data.first["last4"]
      save!
      self.stripe_card_token = nil
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "#{e.message}."
    self.stripe_card_token = nil
    false
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Update plan in stripe then if all good update it in the database
  # -------------------------------------------------------------------------------------------------------------------
  def update_plan(new_plan_id)
    if stripe_customer_id.nil?
      errors.add :base, "Unable to update your plan as there is no existing subscription"
      false
    else
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.plan = new_plan_id
      customer.save
      self.plan_id = new_plan_id
      save!
      true
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to update your plan. #{e.message}."
    false
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Update plan in stripe then if all good update it in the database
  # -------------------------------------------------------------------------------------------------------------------
  def cancel_plan(email)
    if stripe_customer_id.nil?
      errors.add :base, "Unable to cancel your plan as there is no existing subscription"
      false
    else
      customer = Stripe::Customer.retrieve(stripe_customer_id)

      customer.subscriptions.all do |subscription|
        subscription.delete
      end
      self.expired = true
      save!
      true
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to cancel your subscription. #{e.message}."
    false
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------------------------------------------------------------------
  private

  def set_plan
    self.plan_id ||= 'trial'
  end

end
