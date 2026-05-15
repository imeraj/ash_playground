defmodule TunezWeb.Accounts.UserTest do
  use Tunez.DataCase, async: true
  import Tunez.Generator

  test "can create user records" do
    user = generate(user())
    assert is_struct(user, Tunez.Accounts.User)

    two_admins = generate_many(user(role: :admin), 2)
    assert length(two_admins) == 2
    assert Enum.all?(two_admins, &(&1.role == :admin))
  end
end
