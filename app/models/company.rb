class Company < ActiveRecord::Base

  # -------------------------------------------------------------------------------------------------------------------
  # Attributes
  # -------------------------------------------------------------------------------------------------------------------
  attr_accessor :stripe_card_token, :next_invoice
  mount_uploader :logo, LogoUploader

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

  PLANS = {
    trial: {
      index: 0,
      type: "trial",
      name: "trial",
      price: 0,
      interval: "n/a",
      max_jobs: 10,
      max_users: 5,
      branding: { name: 'white labelled', own_logo: true, telephone_support: false }
    },
    basic_monthly: {
      index: 1,
      type: "basic",
      name: "basic monthly",
      price: 29,
      interval: "month",
      max_jobs: 2,
      max_users: 1,
      branding: { name: 'unbranded', own_logo: false, telephone_support: false }
    },
    basic_yearly: {
      index: 2,
      type: "basic",
      name: "basic Yearly",
      price: 290,
      interval: "year",
      max_jobs: 2,
      max_users: 1,
      branding: { name: 'unbranded', own_logo: false, telephone_support: false }
    },
    professional_monthly: {
      index: 3,
      type: "professional",
      name: "professional monthly",
      price: 99,
      interval: "month",
      max_jobs: 10,
      max_users: 5,
      branding: { name: 'white labelled', own_logo: true, telephone_support: false }
    },
    professional_yearly: {
      index: 4,
      type: "professional",
      name: "professional yearly",
      price: 990,
      interval: "year",
      max_jobs: 10,
      max_users: 5,
      branding: { name: 'white labelled', own_logo: true, telephone_support: false }
    },
    enterprise_monthly: {
      index: 5,
      type: "enterprise",
      name: "enterprise monthly",
      price: 499,
      interval: "month",
      max_jobs: 100,
      max_users: 100,
      branding: { name: 'fully brandable', own_logo: true, telephone_support: true }
    },
    enterprise_yearly: {
      index: 6,
      type: "enterprise",
      name: "enterprise yearly",
      price: 4990,
      interval: "year",
      max_jobs: 100,
      max_users: 100,
      branding: { name: 'fully brandable', own_logo: true, telephone_support: true }
    },
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
          customer.card = stripe_card_token
        end
        customer.email = email
        customer.description = name
        customer.save
      end
      self.stripe_customer_id = customer.id
      self.stripe_card_brand = customer.cards.data.first["brand"]
      self.stripe_card_last_4 = customer.cards.data.first["last4"]
      self.active_subscription = true
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
  # Retrieves next invoice from Stripe
  # -------------------------------------------------------------------------------------------------------------------
  def next_invoice?
    if stripe_customer_id.nil?
      errors.add :base, "Unable to find next invoice as there is no existing subscription"
      false
    else
      self.next_invoice = Stripe::Invoice.upcoming(customer: stripe_customer_id)
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    false
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Update plan in stripe then if all good update it in the database
  # -------------------------------------------------------------------------------------------------------------------
  def cancel_subscription(email)
    if stripe_customer_id.nil?
      errors.add :base, "Unable to cancel your plan as there is no existing subscription"
      false
    else
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.cancel_subscription
      self.active_subscription = false
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
