defmodule DatabaseServiceTest do
  use ExUnit.Case, async: true

  test "creates user susccesfully" do
    arguments = %{email: "test@gmail.com", password_hash: "test"}
    context = %{}
    options = []

    assert {:ok, _user} = DatabaseService.run(arguments, context, options)
  end
end
