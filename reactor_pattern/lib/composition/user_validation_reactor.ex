defmodule Composition.UserValidationReactor do
  use Reactor

  input(:user_id)

  step :fetch_user do
    argument(:user_id, input(:user_id))

    run(fn %{user_id: user_id}, _context ->
      {:ok,
       %{
         id: user_id,
         name: "User #{user_id}",
         email: "user#{user_id}@example.com",
         active: true
       }}
    end)
  end

  step :validate_user do
    argument(:user, result(:fetch_user))

    run(fn %{user: user}, _context ->
      if user.active do
        {:ok, user}
      else
        {:error, "User is not active"}
      end
    end)
  end

  return(:validate_user)
end
