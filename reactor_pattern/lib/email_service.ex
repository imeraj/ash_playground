defmodule EmailService do
  use Reactor.Step

  # Simulate realistic email service failures based on email content
  @impl true
  def run(arguments, _context, _options) do
    email = arguments.email

    cond do
      # Simulate network timeout (temporary failure)
      String.contains?(email, "timeout") ->
        {:error, %{type: :network_timeout, message: "Network timeout - please retry"}}

      # Simulate rate limiting (temporary failure)
      String.contains?(email, "ratelimit") ->
        {:error, %{type: :rate_limit, message: "Rate limit exceeded - please retry"}}

      # Simulate blocked email (permanent failure)
      String.contains?(email, "blocked") ->
        {:error, %{type: :blocked_email, message: "Email address is blocked"}}

      # Simulate invalid email (permanent failure)
      not String.contains?(email, "@") ->
        {:error, %{type: :invalid_email, message: "Invalid email format"}}

      # Success case - all other emails work
      true ->
        {:ok,
         %{
           message_id: "msg_#{:rand.uniform(10000)}",
           sent_at: DateTime.utc_now(),
           recipient: email
         }}
    end
  end

  @impl true
  def compensate(error, _arguments, _context, _options) do
    case error do
      # Temporary failures - retry with helpful logging
      %{type: :network_timeout} ->
        IO.puts("🔄 Network timeout - retrying email send...")
        :retry

      %{type: :rate_limit} ->
        IO.puts("🔄 Rate limited - retrying email send...")
        :retry

      # Permanent failures - don't retry
      %{type: :blocked_email} ->
        IO.puts("❌ Email blocked - cannot retry")
        :ok

      %{type: :invalid_email} ->
        IO.puts("❌ Invalid email - cannot retry")
        :ok

      _other ->
        :ok
    end
  end

  @impl true
  def undo(result, _arguments, _context, _options) do
    IO.puts("📧 Canceling email #{result.message_id} to #{result.recipient}")
    :ok
  end
end
