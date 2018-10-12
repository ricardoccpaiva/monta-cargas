defmodule MontaCargasWeb.PageController do
  use MontaCargasWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
