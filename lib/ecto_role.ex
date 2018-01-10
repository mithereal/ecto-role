defmodule EctoRole do

  alias EctoRole.Repo

  @moduledoc """
  Documentation for EctoRole.
  """

  @doc """
  ** Ecto-Role: Implement Table, Row and Column Locking(ish) via OTP **

  ## Examples

      iex> EctoRole.is? "username", "super"
      :false

  """
  def is?(key, role) do
    :false
  end


end
