defmodule Garrahan.AccountsTest do
  use Garrahan.DataCase

  alias Garrahan.Accounts
  alias Garrahan.Accounts.User

  describe "users" do

    @valid_attrs %{password: "some password", is_admin: true}
    @update_attrs %{password: "some updated password", is_admin: false}
    @invalid_attrs %{password: nil}

    setup do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      {:ok, user: user}
    end

    defp are_same_user(user1, user2) do
      assert user1.id == user2.id
    end

    test "list_users/0 returns all users", %{user: user} do
      Accounts.list_users()
      |> Enum.map(fn u ->
        are_same_user(u, user)
      end)
    end

    test "get_user!/1 returns the user with given id", %{user: user} do
      are_same_user(Accounts.get_user!(user.id), user)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.password == @valid_attrs.password
      assert is_binary(user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user", %{user: user} do
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.password == @update_attrs.password
      assert is_binary(user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      are_same_user(Accounts.get_user!(user.id), user)
    end

    test "delete_user/1 deletes the user", %{user: user} do
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset", %{user: user} do
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
