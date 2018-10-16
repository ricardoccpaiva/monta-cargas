defmodule MontaCargasWeb.Router do
  use MontaCargasWeb, :router

  pipeline :unauthorized do
    plug(:fetch_session)
  end

  pipeline :authorized do
    plug(:fetch_session)

    plug(Guardian.Plug.Pipeline,
      module: MontaCargasWeb.Guardian,
      error_handler: MontaCargasWeb.Guardian.ErrorHandler
    )

    plug(Guardian.Plug.EnsureAuthenticated)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MontaCargasWeb do
    # Use the default browser stack
    pipe_through(:browser)
    pipe_through(:authorized)

    get("/", PageController, :index)
  end

  scope "/auth", MontaCargasWeb do
    pipe_through([:browser])
    pipe_through(:unauthorized)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end
end
