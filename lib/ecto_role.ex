defmodule EctoRole do

  alias EctoRole.Repo

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
      :false

  """
  def filter(key, struct) do
    :false
  end


end
