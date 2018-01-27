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

alias EctoRole.{Entity, Permission, Role, Schema, Repo}
alias EctoRole.Entity.Role, as: ER
alias EctoRole.Permission.Role, as: PR

### entity

changeset = Entity.changeset(%Entity{}, %{})

entity1 = Repo.insert!(changeset)

changeset = Entity.changeset(%Entity{}, %{})

entity2 = Repo.insert!(changeset)

changeset = Entity.changeset(%Entity{}, %{})

entity3 = Repo.insert!(changeset)

## role
changeset =
  Role.changeset(%Role{}, %{
    name: "Admin"
  })

role1 = Repo.insert!(changeset)

changeset =
  Role.changeset(%Role{}, %{
    name: "Operator"
  })

role2 = Repo.insert!(changeset)

changeset =
  Role.changeset(%Role{}, %{
    name: "User"
  })

role3 = Repo.insert!(changeset)

## schema

changeset =
  Schema.changeset(%Schema{}, %{
    name: "user",
    fields: "username, email"
  })

schema1 = Repo.insert!(changeset)

### Permission

changeset =
  Permission.changeset(%Permission{}, %{
    name: "user account (users table)",
    read: "username, email",
    write: "username, email",
    create: true,
    delete: false,
    schema_id: 1
  })

permission1 = Repo.insert!(changeset)

changeset =
  Permission.changeset(%Permission{}, %{
    name: "operator account (users table)",
    read: "username, email",
    write: "username, email",
    create: true,
    delete: false,
    schema_id: 1
  })

permission2 = Repo.insert!(changeset)

changeset =
  Permission.changeset(%Permission{}, %{
    name: "admin account (users table)",
    read: "username, email",
    write: "username, email",
    create: true,
    delete: false,
    schema_id: 1
  })

permission3 = Repo.insert!(changeset)

## Joins

changeset =
  ER.changeset(%ER{}, %{
    role_key: role1.key,
    entity_key: entity1.key
  })

Repo.insert!(changeset)

changeset =
  ER.changeset(%ER{}, %{
    role_key: role2.key,
    entity_key: entity2.key
  })

Repo.insert!(changeset)

changeset =
  PR.changeset(%PR{}, %{
    role_key: role1.key,
    permission_key: permission1.key
  })

Repo.insert!(changeset)

changeset =
  PR.changeset(%PR{}, %{
    role_key: role2.key,
    permission_key: permission2.key
  })

Repo.insert!(changeset)
