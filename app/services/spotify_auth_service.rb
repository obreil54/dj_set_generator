require "faraday"
require "json"
require "base64"

class SpotifyAuthService
  SPOTIFY_AUTH_URL = "https://accounts.spotify.com/api/token"

  @access_token = nil
  @expires_at = Time.now

  def self.get_access_token
    return @access_token if @access_token && Time.now < @expires_at

    response = Faraday.post(SPOTIFY_AUTH_URL) do |req|
      req.headers["Authorization"] = "Basic #{Base64.strict_encode64("#{ENV["SPOTIFY_CLIENT_ID"]}:#{ENV["SPOTIFY_CLIENT_SECRET"]}")}"
      req.headers["Content-Type"] = "application/x-www-form-urlencoded"
      req.body = "grant_type=client_credentials"
    end

    parsed_response = JSON.parse(response.body)

    case response.status
    when 200
      unless parsed_response["access_token"]
        raise StandardError, "Spotify authentication response missing access_token: #{parsed_response}"
      end

      @access_token = parsed_response["access_token"]
      @expires_at = Time.now + parsed_response["expires_in"].to_i
      Rails.logger.info("New Spotify access token retrived, expires at #{@expires_at}")

      @access_token
    when 401
      raise StandardError, "Spotify authentication failed: Invalid client credentials"
    when 500..599
      raise StandardError, "Spotify authentication failed: Server error (#{response.status})"
    else
      raise StandardError, "Spotify authentication failed: Unexpected response (#{response.status}) - #{parsed_response}"
    end
  end
end
