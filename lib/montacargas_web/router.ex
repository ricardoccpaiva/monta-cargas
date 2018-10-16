defmodule MontaCargasWeb.Router do
  use MontaCargasWeb, :router

  pipeline :auth do
    plug(Guardian.Plug.Pipeline,
      module: MontaCargasWeb.Guardian,
      error_handler: MontaCargasWeb.Guardian.ErrorHandler
    )

    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.VerifyHeader)
  end

  pipeline :ensure_auth do
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

  scope "/login", MontaCargasWeb do
    pipe_through([:browser, :auth])

    get("/", LoginController, :index)
  end

  scope "/", MontaCargasWeb do
    pipe_through([:browser, :auth, :ensure_auth])

    get("/", PageController, :index)
  end

  scope "/auth", MontaCargasWeb do
    pipe_through([:browser])

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end
end
