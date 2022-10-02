defmodule InvoicerWeb.Router do
  use InvoicerWeb, :router
  alias InvoicerWeb.Plug.FetchUser
  alias InvoicerWeb.Plug.RestrictAccess

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {InvoicerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_restricted do
    plug :browser
    plug FetchUser
    plug RestrictAccess
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug FetchUser
  end

  scope "/", InvoicerWeb do
    pipe_through :browser_restricted

    get "/invoices/:id", InvoiceController, :show
  end

  scope "/api" do
    pipe_through :api

    get "/", Absinthe.Plug.GraphiQL, schema: InvoicerWeb.Api.Schema, interface: :playground

    post "/", Absinthe.Plug,
      schema: InvoicerWeb.Api.Schema,
      before_send: {GraphQLTools.SessionHelpers, :before_send}
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
