defmodule ResilientUserRegistration do
  @moduledoc false
  use Reactor

  input(:email)
  input(:password)

  step :validate_email do
    argument(:email, input(:email))

    run(fn %{email: email}, _context ->
      if String.contains?(email, "@") do
        {:ok, email}
      else
        {:error, "Email must contain @"}
      end
    end)
  end

  step :hash_password do
    argument(:password, input(:password))

    run(fn %{password: password}, _context ->
      hashed = :crypto.hash(:sha256, password) |> Base.encode16()
      {:ok, hashed}
    end)
  end

  step :create_user, DatabaseService do
    argument(:email, result(:validate_email))
    argument(:password_hash, result(:hash_password))
    max_retries(3)
  end

  step :send_welcome_email, EmailService do
    argument(:email, result(:validate_email))
    argument(:user, result(:create_user))
    max_retries(2)
  end

  step :send_admin_notification, NotificationService do
    argument(:user, result(:create_user))
    max_retries(1)
  end

  return(:create_user)
end
