defmodule InvoicerWeb.Api.UserTypes do
  use Absinthe.Schema.Notation
  alias InvoicerWeb.Api.UserResolvers
  import GraphQLTools.SchemaHelpers

  enum :role do
    value(:regular)
    value(:admin)
  end

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :role, non_null(:role)
  end

  object :user_queries do
    field :current_user, :user do
      resolve(&UserResolvers.current_user/2)
    end

    field :user, :user do
      arg(:id, non_null(:id))
      middleware(InvoicerWeb.Api.Middleware.RequireRole, :admin)
      resolve(&UserResolvers.get_user/2)
    end

    field :users, non_null(list_of(non_null(:user))) do
      middleware(InvoicerWeb.Api.Middleware.RequireRole, :admin)
      resolve(&UserResolvers.list_users/2)
    end
  end

  object :user_mutation_result do
    mutation_result_fields(:user)
  end

  object :sign_in_mutation_result do
    mutation_result_fields(:user)
  end

  input_object :create_user_params do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
    field :role, non_null(:role), default_value: :regular
  end

  object :user_mutations do
    field :sign_in, non_null(:sign_in_mutation_result) do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      middleware(InvoicerWeb.Api.SignIn)
    end

    @desc "Signs user out, removing all user data from the session."
    field :sign_out, non_null(:boolean) do
      middleware(InvoicerWeb.Api.Middleware.SignOut)
    end
  end
end
