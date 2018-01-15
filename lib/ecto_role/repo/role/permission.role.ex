defmodule EctoRole.Permission.Role do

  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Repo, as: Repo

  alias EctoRole.Permission.Role

  schema "er.role_to_permission" do
    field :role_id, :integer
    field :permission_id, :integer

  end

  @params ~w(role_id permission_id)a
  @required_fields ~w(role_id permission_id)a


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
  end


end