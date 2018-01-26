defmodule EctoRole do
  config = Application.get_env(:ecto_role, EctoRole, [])
  @repo Keyword.get(config, :repo)

  if config == [], do: raise("EctoRole configuration is required")
  if is_nil(@repo), do: raise("EctoRole requires a repo")

  @moduledoc """
  Ecto-Role: Implement Table, Row and Column Locking(ish) via OTP
  """

  @doc """
  ** is?: checks if username is role **

  ## Examples

      iex> EctoRole.is? "username", "super"
      :false

  """
  def is?(key, role) do
    false
  end

  @doc """
  ** filter: filters struct based on role/struct **

  ## Examples

      iex> EctoRole.filter "key", %{}
      %{}

  """
  def filter(key, struct) do
    struct
  end

  def repo do
    :ecto_role
    |> Application.fetch_env!(EctoRole)
  end
end
