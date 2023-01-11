defmodule Invoicer.Repo.Migrations.AddTemplateNameToClients do
  use Ecto.Migration
  alias Invoicer.Clients.Client

  def change do
    Client.TemplateType.create_type()

    alter table(:clients) do
      add :template_type, Client.TemplateType.type()
      add :is_default_template, :boolean, null: false, default: false
    end

    create unique_index(:clients, [:user_id, :template_type, :is_default_template],
             where: "is_default_template = true"
           )
  end
end
