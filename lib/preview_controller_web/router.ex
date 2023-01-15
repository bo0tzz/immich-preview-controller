defmodule PreviewControllerWeb.Router do
  use PreviewControllerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {PreviewControllerWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PreviewControllerWeb do
    pipe_through(:browser)

    # get "/", PreviewController, :index
    # get "/:id", PreviewController, :edit
    resources("/", PreviewController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PreviewControllerWeb do
  #   pipe_through :api
  # end
end
