# EctoRole

[![Build Status](https://travis-ci.org/mithereal/ecto-role.svg?branch=master)](https://travis-ci.org/mithereal/ecto-role)

[![Inline docs](http://inch-ci.org/github/mithereal/ecto-role.svg)](http://inch-ci.org/github/mithereal/ecto-role)

** Ecto-Role: Implement Table, Row and Column Locking(ish) via OTP **

Add Role based authentication to your otp app. Ecto-Role Provides a simple way to create and assign roles to users

Ecto-Role creates a few schemas to track roles and entities,

Entities are a object we are assiging the role to, entities have a uuid.

Schemas represent the schema and its fields/permissions -- permissions is a list of all permissions relating to the schema

a Permission has a name, which fields are filtered in the result and if create/delete actions can/not happen

we have a few different ways of looking at this:

* Entities have roles which have permissions
* Roles have entites and permissions
* Schemas have fields (row_names) and permissions
* Permissions explain how to filter data/actions

By using the entity instead of user we can have many different permissions/filters for different objects and by holding this information in an otp app we can easily query for the permissions on the entity with no need to hit the database 


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_role` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_role, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecto_role](https://hexdocs.pm/ecto_role).

