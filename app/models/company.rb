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

  # Used when updating Stripe subscription
  def save_with_payment(email)
    if valid?
      if stripe_customer_id.nil? # New to stripe
        # if stripe_card_token.blank?
        #   raise "Stripe token not present. Can't create account."
        # end
        customer = Stripe::Customer.create(email: email, description: name, plan: plan_id, card: stripe_card_token)
        self.stripe_customer_token = customer.id
        save!
      else
        customer = Stripe::Customer.retrieve(stripe_customer_id)
        if stripe_card_token.present?
          customer.card = stripe_token
        end
        customer.email = email
        customer.description = name
        customer.save
      end
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "#{e.message}."
    self.stripe_card_token = nil
    false
  end

  # def update_stripe(email)
  #   # return if email.include?(ENV['ADMIN_EMAIL'])
  #   # return if email.include?('@example.com') and not Rails.env.production?
  #   if stripe_customer_id.nil?
  #     if !stripe_token.present?
  #       raise "Stripe token not present. Can't create account."
  #     end
  #     customer = Stripe::Customer.create(
  #       :email => email,
  #       :description => name,
  #       :card => stripe_token,
  #       :plan => roles.first.name
  #     )
  #   else
  #     customer = Stripe::Customer.retrieve(stripe_customer_id)
  #     if stripe_token.present?
  #       customer.card = stripe_token
  #     end
  #     customer.email = email
  #     customer.description = name
  #     customer.save
  #   end
  #   # self.last_4_digits = customer.cards.data.first["last4"]
  #   self.stripe_customer_id = customer.id
  #   self.stripe_token = nil
  # rescue Stripe::StripeError => e
  #   logger.error "Stripe Error: " + e.message
  #   errors.add :base, "#{e.message}."
  #   self.stripe_token = nil
  #   false
  # end



  # -------------------------------------------------------------------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------------------------------------------------------------------
  private

  def set_plan
    self.plan ||= 'trial'
  end

end
