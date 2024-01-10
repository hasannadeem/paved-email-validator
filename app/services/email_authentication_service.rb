# frozen_string_literal: true

class EmailAuthenticationService
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_reader :email_address, :email

  def initialize(email_address, headers)
    @email_address = email_address
    @email = Mail.new headers
  end

  def process
    {
      valid_dkim_spf: valid_dkim? && valid_spf?,
      valid_dns_records: valid_dns?,
      tls_verification: tls_verification_used?,
      message_format_validation: valid_email_format?,
      unsubscribe_link_present: unsubscribe_link_present?,
      dmarc_authenticated: dmarc_authenticated?,
      email_address: email_address
    }
  end

  private

  def valid_dns?
    validated_email_address = ValidEmail2::Address.new(email_address)
    validated_email_address&.valid_mx?
  end

  def valid_dkim?
    auth_result = email.header['Authentication-Results']&.unparsed_value.include?('dkim=pass')
    dkim_signatures = email.header['DKIM-Signature']

    !dkim_signatures.nil? && (dkim_signatures.is_a?(Array) ? dkim_signatures.any?(&:unparsed_value) : dkim_signatures.unparsed_value.present?) && auth_result
  end

  def valid_spf?
    auth_result = email.header['Authentication-Results']&.unparsed_value.include?('spf=pass')
    received_spfs = email.header['Received-SPF']

    !received_spfs.nil? && (received_spfs.is_a?(Array) ? received_spfs.any?(&:unparsed_value) : received_spfs.unparsed_value.present?) && auth_result
  end

  def valid_email_format?
    (email_address =~ VALID_EMAIL_REGEX) ? true : false
  end

  def dmarc_authenticated?
    email.header['Authentication-Results']&.unparsed_value.include?('dmarc=pass')
  end

  def unsubscribe_link_present?
    email.header['List-Unsubscribe']&.unparsed_value.present?
  end

  def tls_verification_used?
    # this is the documentation which says
    # https://www.rfc-editor.org/rfc/rfc5322#appendix-A.4
    # with ESMTP

    # TLS (Transport Layer Security) is a cryptographic protocol
    # that provides secure communication over the internet.
    # It is commonly used to encrypt SMTP traffic to protect email messages
    #  from being intercepted and read by unauthorized parties.

    # ESMTP (Extended Simple Mail Transfer Protocol with Transport Layer Security)
    # is an extension of SMTP that uses TLS
    # to provide secure communication between email servers.

    received_field = email.header['Received']

    !received_field.nil? && (received_field.is_a?(Array) ? received_field.any? {|rf| rf.unparsed_value.include?('with ESMTP')} : received_field.unparsed_value.include?('with ESMTP'))
  end
end
