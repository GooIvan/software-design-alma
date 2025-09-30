class AuthorizeApiRequest
  def self.call(headers = {})
    new(headers).call
  end

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user_found = user
    if user_found
      {
        success: true,
        user: user_found
      }
    else
      {
        success: false,
        message: "Invalid or missing token",
        user: nil
      }
    end
  end

  private

  attr_reader :headers

  def user
    return nil unless decoded_auth_token
    
    @user ||= User.find(decoded_auth_token[:user_id])
  rescue ActiveRecord::RecordNotFound
    nil
  rescue
    nil
  end

  def decoded_auth_token
    return nil unless http_auth_header
    
    # Check if token is blacklisted first
    return nil if JwtDenylist.exists?(jti: http_auth_header)
    
    @decoded_auth_token ||= JwtService.decode(http_auth_header)
  rescue JWT::DecodeError
    nil
  rescue
    nil
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    nil
  end
end
