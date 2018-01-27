defmodule EctoRole.Permission.Role do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "er_role_to_permission" do
    belongs_to(:role, EctoRole.Role, foreign_key: :role_key, references: :key, type: :string)

    belongs_to(
      :permission,
      EctoRole.Permission,
      foreign_key: :permission_key,
      references: :key,
      type: :string
    )
  end

  @params ~w(role_key permission_key)a
  @required_fields ~w()a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
  end
end
