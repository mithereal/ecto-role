defmodule EctoRole.Filter.Read do
  @moduledoc """
    Schema: Represents a Read Schema and associated Fields
    name is the name of the table
  """

  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query


  alias EctoRole.Repo, as: Repo

  embedded_schema do
    field :fields
  end



  @params ~w()a
  @required_fields ~w()a
  @ignored_schemas ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
  end


end
