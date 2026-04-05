defmodule AshDemoWeb.PageController do
  use AshDemoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
