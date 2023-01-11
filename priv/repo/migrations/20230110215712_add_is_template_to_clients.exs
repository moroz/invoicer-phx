defmodule Invoicer.Repo.Migrations.AddTemplateNameToClients do
  use Ecto.Migration
  alias Invoicer.Clients.Client
  alias Invoicer.Clients.Client.TemplateType

  def change do
    TemplateType.create_type()

    alter table(:clients) do
      add :template_type, TemplateType.type()
      add :is_default_template, :boolean, null: false, default: false
    end

    create unique_index(:clients, [:user_id, :template_type], where: "is_default_template = true")

    execute """
    create or replace function unset_default_templates()
    returns trigger
    language plpgsql as $$
      begin
        update clients c
        set is_default_template = false
        where c.user_id = new.user_id and c.template_type = new.template_type
          and c.is_default_template = true;

        return new;
      end;
    $$;
    """

    execute """
    create trigger unset_default_templates_on_insert
    before insert on clients 
    for each row
    when (new.is_default_template = true)
    execute procedure unset_default_templates();
    """

    execute """
    create trigger unset_default_templates_on_update
    before update on clients 
    for each row
    when (new.is_default_template = true and old.is_default_template = false)
    execute procedure unset_default_templates();
    """
  end

  def down do
    execute "drop trigger unset_default_templates_on_update on clients"
    execute "drop trigger unset_default_templates_on_insert on clients"
    execute "drop function unset_default_templates()"

    alter table(:clients) do
      remove :template_type
      remove :is_default_template
    end

    TemplateType.drop_type()
  end
end
