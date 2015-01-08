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
  def has_jobs?
    self.jobs.any?
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Create or Update Stripe subscription
  # -------------------------------------------------------------------------------------------------------------------
  def save_with_payment(email)
    if valid?
      if stripe_customer_id.nil? # New to stripe
        if stripe_card_token.blank?
          raise "Stripe token not present. Can't create account."
        end
        customer = Stripe::Customer.create(
          email: email,
          description: name,
          plan: plan_id,
          card: stripe_card_token
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
  # Private Methods
  # -------------------------------------------------------------------------------------------------------------------
  private

  def set_plan
    self.plan_id ||= 'trial'
  end

end
