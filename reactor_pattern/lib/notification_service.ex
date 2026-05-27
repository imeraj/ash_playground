defmodule NotificationService do
  use Reactor.Step

  @impl true
  def run(arguments, _context, _options) do
    user = arguments.user

    # Admin notifications always succeed (internal system)
    {:ok,
     %{
       notification_id: "notif_#{:rand.uniform(10000)}",
       sent_at: DateTime.utc_now(),
       message: "New user registered: #{user.email}"
     }}
  end

  @impl true
  def undo(result, _arguments, _context, _options) do
    IO.puts("🔔 Canceling admin notification #{result.notification_id}")
    :ok
  end
end
