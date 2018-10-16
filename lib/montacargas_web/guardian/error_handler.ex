defmodule MontaCargasWeb.Guardian.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    redirect(conn, to: "/login")
  end

  def auth_error(conn, {type, _reason}, _opts) do
    IO.inspect("-----> #{type}")
  end
end
