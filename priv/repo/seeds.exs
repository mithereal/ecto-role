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
 alias EctoRole.Entry.Role, as: ER
 alias EctoRole.Permission.Role, as: PR

### entity

changeset = Entity.changeset(%Entity{}, %{
})

Repo.insert!(changeset)

changeset = Entity.changeset(%Entity{}, %{
})

Repo.insert!(changeset)

changeset = Entity.changeset(%Entity{}, %{
})

Repo.insert!(changeset)

## role
 changeset = Role.changeset(%Role{}, %{
   name: "Admin"
   })

Repo.insert!(changeset)

changeset = Role.changeset(%Role{}, %{
  name: "Operator"
})

Repo.insert!(changeset)

 changeset = Role.changeset(%Role{}, %{
   name: "User"
   })

Repo.insert!(changeset)

## schema

changeset = Schema.changeset(%Schema{}, %{
  name: "user",
  fields: "username, email"
})

Repo.insert!(changeset)

### Permission

changeset = Permission.changeset(%Permission{}, %{
            name: "user account (users table)",
            read: "username, email",
            write: "username, email",
            create: true,
            delete: false,
            schema_id 1

})

Repo.insert!(changeset)

changeset = Permission.changeset(%Permission{}, %{
            name: "operator account (users table)",
            read: "username, email",
            write: "username, email",
            create: true,
            delete: false,
           schema_id 1

})

Repo.insert!(changeset)

changeset = Permission.changeset(%Permission{}, %{
  name: "admin account (users table)",
  read: "username, email",
  write: "username, email",
  create: true,
  delete: false,
schema_id 1


})

Repo.insert!(changeset)


