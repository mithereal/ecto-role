defmodule EctoRole.Entity.Role do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "er_role_to_entity" do
    field(:role_key, :string)
    field(:entity_key, :string)
  end

  @params ~w(role_key entity_key)a
  @required_fields ~w(role_key entity_key)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
  end
end
