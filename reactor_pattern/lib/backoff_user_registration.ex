defmodule BackoffUserRegistration do
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

    run(fn %{email: email, password_hash: hash}, _context ->
      if :rand.uniform() < 0.7 do
        {:error, "Simulated DB error"}
      else
        user = %{
          id: :rand.uniform(10000),
          email: email,
          password_hash: hash,
          created_at: DateTime.utc_now()
        }

        {:ok, user}
      end
    end)

    compensate(fn _error, _args, _context ->
      # Database errors are usually retryable
      :retry
    end)

    # DSL backoff function (only available with anonymous run functions)
    backoff(fn _error, _args, context ->
      retry_count = Map.get(context, :current_try, 0)
      # Exponential backoff: 1s, 2s, 4s, 8s...
      delay = (:math.pow(2, retry_count) * 1000) |> round()
      IO.puts("🔄 Database retry #{retry_count + 1} - waiting #{delay}ms")
      delay
    end)
  end

  return(:create_user)
end
