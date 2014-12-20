class Subdomain

  def self.matches?(request)
    if request.subdomain.present? && request.subdomain != 'www'
      account = Company.find_by subdomain: request.subdomain
      return true if account # -> if account is not found, return false (IE no route)
    end
  end

  # def initialize
  #   @companies = Company.all
  # end

  # def matches?(request)
  #   if request.subdomain.present? && request.subdomain != 'www'
  #     @companies.include?(request.subdomain)
  #   end
  # end

end