defmodule EctoRole.Role do

  @moduledoc """
  Role: Represents a Role and Permissions for an associated Entity.
"""

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query


  alias EctoRole.Role, as: APP
  alias EctoRole.Role.Role, as: ROLE
  alias EctoRole.Permission, as: PERMISSION
  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Permission.Role, as: PR
  alias EctoRole.Entity.Role, as: ER

  config = Application.get_env(:ecto_role, EctoRole, [])
  @repo Keyword.get(config, :repo)

  if config == [], do: raise("EctoRole configuration is required")
  if is_nil(@repo), do: raise("EctoRole requires a repo")

  def repo do
    :ecto_role
    |> Application.fetch_env!(EctoRole)
    |> Keyword.fetch!(:repo)
  end


end