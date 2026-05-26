defmodule UserRegistration do
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

  step :create_user do
    argument(:email, result(:validate_email))
    argument(:password_hash, result(:hash_password))

    run(fn %{email: email, password_hash: password_hash}, _context ->
      user = %{
        id: :rand.uniform(10000),
        email: email,
        password_hash: password_hash,
        created_At: DateTime.utc_now()
      }

      {:ok, user}
    end)
  end

  return(:create_user)
end
