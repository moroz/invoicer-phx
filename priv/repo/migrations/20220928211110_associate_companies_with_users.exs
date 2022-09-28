defmodule Invoicer.Repo.Migrations.AssociateCompaniesWithUsers do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
