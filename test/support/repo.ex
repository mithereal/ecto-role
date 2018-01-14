defmodule EctoRole.Test.Repo do
  use Ecto.Repo, otp_app: :ecto_role

  def log(_cmd), do: nil
end