require "test_helper"
require "webmock/minitest"

class SpotifyAuthServiceTest < ActiveSupport::TestCase
  def setup
    @mock_access_token = "mock_access_token"

    stub_request(:post, "https://accounts.spotify.com/api/token")
      .with(
        headers: {
          "Authorization" => "Basic #{Base64.strict_encode64("#{ENV["SPOTIFY_CLIENT_ID"]}:#{ENV["SPOTIFY_CLIENT_SECRET"]}")}",
          "Content-Type" => "application/x-www-form-urlencoded"
        },
        body: "grant_type=client_credentials"
      )
      .to_return(
        status: 200,
        body: {
          access_token: @mock_access_token,
          token_type: "Bearer",
          expires_in: 3600
        }.to_json,
        headers: {"Content-Type" => "application/json"}
      )
  end

  def teardown
    SpotifyAuthService.instance_variable_set(:@access_token, nil)
    SpotifyAuthService.instance_variable_set(:@expires_at, Time.now)
    WebMock.reset!
  end

  def test_get_access_token_returns_valid_token
    token = SpotifyAuthService.get_access_token
    assert_equal @mock_access_token, token
  end

  def test_access_token_is_cached_until_expiry
    SpotifyAuthService.get_access_token

    assert_requested(:post, "https://accounts.spotify.com/api/token", times: 1)

    token = SpotifyAuthService.get_access_token
    assert_equal @mock_access_token, token
  end

  def test_get_access_token_refreshes_after_expiry
    SpotifyAuthService.get_access_token

    SpotifyAuthService.instance_variable_set(:@expires_at, Time.now - 1)

    SpotifyAuthService.get_access_token

    assert_requested(:post, "https://accounts.spotify.com/api/token", times: 2)
  end

  def test_get_access_token_handles_invalid_credentials
    stub_request(:post, "https://accounts.spotify.com/api/token")
      .to_return(status: 401, body: {error: "invalid_client"}.to_json)

    assert_raises(StandardError) { SpotifyAuthService.get_access_token }
  end

  def test_get_access_token_handles_api_failure
    stub_request(:post, "https://accounts.spotify.com/api/token")
      .to_return(status: 500, body: {error: "Internal Server Error"}.to_json)

    assert_raises(StandardError) { SpotifyAuthService.get_access_token }
  end

  def test_get_access_token_handles_missing_access_token
    stub_request(:post, "https://accounts.spotify.com/api/token")
      .to_return(status: 200, body: {token_type: "Bearer", expires_in: 3600}.to_json)

    assert_raises(StandardError) { SpotifyAuthService.get_access_token }
  end
end
