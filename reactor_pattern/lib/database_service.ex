defmodule DatabaseService do
  use Reactor.Step

  @impl true
  def run(arguments, _context, _options) do
    user = %{
      id: :rand.uniform(10000),
      email: arguments.email,
      password_hash: arguments.password_hash,
      created_at: DateTime.utc_now()
    }

    {:ok, user}
  end

  @impl true
  def compensate(_error, _arguments, _context, _options) do
    # Database errors are usually retryable
    :retry
  end

  @impl true
  def undo(user, _arguments, _context, _options) do
    IO.puts("Rolling back user creation for #{user.email} (ID: #{user.id})")
    :ok
  end
end
