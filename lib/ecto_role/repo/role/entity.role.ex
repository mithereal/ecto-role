defmodule EctoRole.Entity.Role do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "er.role_to_entity" do
    field(:role_id, :integer)
    field(:entity_id, :integer)
  end

  @params ~w(role_id entity_id)a
  @required_fields ~w(role_id entity_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
  end
end
