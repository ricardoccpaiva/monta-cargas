defmodule MontaCargasWeb.Guardian.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    redirect(conn, to: "/auth/google")
  end
end
