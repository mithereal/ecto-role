defmodule EctoRole.Filter.Role do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoRole.Role, as: ROLE
  alias EctoRole.Filter, as: FILTER

  schema "er_role_to_filter" do
    belongs_to(:role, ROLE, [foreign_key: :role_key, references: :key, type: :string])

   belongs_to(
      :filter,
      FILTER,
    [
      foreign_key: :filter_key,
      references: :key,
      type: :string
     ]
    )

#    field(:role_key, :string)
#    field(:filter_key, :string)
  end

  @params ~w(role_key filter_key)a
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
