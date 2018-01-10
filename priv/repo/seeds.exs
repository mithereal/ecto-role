# Sample script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# Repositories directly:
#
#     EctoRole.Repo.insert!(%EctoRole.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# alias EctoRole.{Role, Entity, Permission, Schema}
# alias EctoRole.Repo
#
# entity1_changeset = Entity.changeset(%Entity{}, %{
#   name: "Cash",
#   type: "asset"
#   })
#
#
# entity2_changeset = Entity.changeset(%Entity{}, %{
#   name: "Loan",
#   type: "liability"
#   })
#
# entity3_changeset = Entity.changeset(%Entity{}, %{
#   name: "David",
#   type: "equity"
#   })
#
# e1 = Repo.insert!(entity1_changeset)
# e2 = Repo.insert!(entity2_changeset)
# e3 = Repo.insert!(entity3_changeset)
#
#
# entry1 = Repo.insert! %Entry{
#   description: "Initial Deposit",
#   date: %Ecto.Date{ year: 2016, month: 1, day: 14 }
# }
#
# entry2 = Repo.insert! %Entry{
#   description: "Purchased paper",
#   date: %Ecto.Date{ year: 2016, month: 1, day: 15 }
# }
#
# entry2 = Repo.insert! %Entry{
#   description: "Sold Asset",
#   date: %Ecto.Date{ year: 2016, month: 1, day: 16 }
# }
#
# amount1 = Repo.insert! %Amount{
#   amount: Decimal.new(2400.00),
#   type: "credit",
#   account_id: 1,
#   entry_id: 1
# }
#
# amount2 = Repo.insert! %Amount{
#   amount: Decimal.new(2400.00),
#   type: "debit",
#   account_id: 2,
#   entry_id: 1
# }
#
# changeset = Entry.changeset %Entry{
#   description: "Buying first Porsche",
#   date: %Ecto.Date{ year: 2016, month: 1, day: 16 },
#   amounts: [ %Amount{ amount: Decimal.new(125000.00), type: "credit", account_id: 2 },
#              %Amount{ amount: Decimal.new(50000.00), type: "debit", account_id: 1 } ,
#              %Amount{ amount: Decimal.new(75000.00), type: "debit", account_id: 1 } ]
# }
#
# IO.inspect changeset
# IO.inspect changeset.valid?
# Repo.insert!(changeset)
#
# Repo.insert! %Entry{
#   description: "Buying first G6",
#   date: %Ecto.Date{ year: 2016, month: 1, day: 16 },
#   amounts: [ %Amount{ amount: Decimal.new(1250000.00), type: "credit", account_id: 2 },
#              %Amount{ amount: Decimal.new(500000.00), type: "debit", account_id: 1 } ,
#              %Amount{ amount: Decimal.new(705000.00), type: "debit", account_id: 1 } ]
# }