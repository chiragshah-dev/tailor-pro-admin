class ContactInfo < ApplicationRecord
  # validations
  validates :contact_number, numericality: { only_integer: true }, length: { is: 10 }, allow_blank: true
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP, 
    message: "must be a valid email address (e.g., example@example.com)" 
  }, allow_blank: true

  validate :website_url_format, if: -> { website_url.present? }

  private

  def website_url_format
    uri = URI.parse(website_url)
    # Check for HTTP or HTTPS scheme
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      errors.add(:website_url, 'must be a valid HTTP or HTTPS URL (e.g., https://example.com)')
      return # Exit if scheme fails
    end

    # Check if host exists and is a valid domain
    unless uri.host.present? && uri.host.match?(/\A[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]*[a-z0-9])*)*\.[a-z]{2,}\z/i)
      errors.add(:website_url, 'must include a valid domain (e.g., example.com)')
    end
  rescue URI::InvalidURIError
    errors.add(:website_url, 'is not a valid URL')
  end
end
