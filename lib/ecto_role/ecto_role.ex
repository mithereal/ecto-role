defmodule EctoRole do


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
    :false
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