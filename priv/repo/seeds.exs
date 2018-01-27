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

 alias EctoRole.{Entity, Permission, Role, Entry.Role, Permission.Role, Schema, Repo}

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


### Permission

changeset = Permission.changeset(%Permission{}, %{
            name: "user",
            read: "username, email",
            write: "username, email",
            create: true,
            delete: false,

})

Repo.insert!(changeset)

changeset = Permission.changeset(%Permission{}, %{
            name: "settings",
            read: "name, value",
            write: "name",
            create: true,
            delete: false,

})

Repo.insert!(changeset)