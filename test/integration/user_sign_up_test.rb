require "test_helper"

class UserSignUpTest < ActionDispatch::IntegrationTest
  test "user can sign up with valid details" do
    get new_user_registration_path
    assert_response :success

    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: {
          first_name: "Test",
          last_name: "User",
          username: "testuser",
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123",
        }
      }
    end

    follow_redirect!
    assert_response :success
  end

  test "user cannot sign up without email" do
    post user_registration_path, params: {
      user: {
        first_name: "Test",
        last_name: "User",
        username: "testuser",
        email: "",
        password: "password123",
        password_confirmation: "password123",
      }
    }

    assert_response :unprocessable_entity
  end

  test "user cannot sign up with invalid email" do
    post user_registration_path, params: {
      user: {
        first_name: "Test",
        last_name: "User",
        username: "testuser",
        email: "test@example",
        password: "password123",
        password_confirmation: "password123",
      }
    }

    assert_response :unprocessable_entity
  end

  test "user cannot sign up with a short password" do
    post user_registration_path, params: {
      user: {
        first_name: "Test",
        last_name: "User",
        username: "testuser",
        email: "test@example.com",
        password: "123",
        password_confirmation: "123",
      }
    }

    assert_response :unprocessable_entity
  end

  test "user cannot sign up with mismatched passwords" do
    post user_registration_path, params: {
      user: {
        first_name: "Test",
        last_name: "User",
        username: "testuser",
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password",
      }
    }

    assert_response :unprocessable_entity
  end

  test "user cannot sign up with an existing email" do
    post user_registration_path, params: {
      user: {
        first_name: "Ilya",
        last_name: "Obretetskiy",
        username: "DJ ILS",
        email: "obreil54@gmail.com",
        password: "password123",
        password_confirmation: "password123",
      }
    }

    assert_response :unprocessable_entity
  end
end
