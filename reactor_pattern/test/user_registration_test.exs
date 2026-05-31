defmodule UserRegistrationTest do
  use ExUnit.Case, async: true

  test "validates correct email format" do
    arguments = %{email: "user@example.com"}
    context = %{}

    assert {:ok, "user@example.com"} =
             UserRegistration.validate_email_address(arguments, context)
  end

  test "successful user registration flow" do
    inputs = %{
      email: "user@example.com",
      password: "secure_password"
    }

    assert {:ok, %{id: user_id}} = Reactor.run(UserRegistration, inputs, async?: false)
    assert user_id
  end

  test "handles invalid email gracefully" do
    inputs = %{
      email: "invalid-email",
      password: "secure_password"
    }

    assert {:error, _reason} = Reactor.run(UserRegistration, inputs, async?: false)
  end
end
