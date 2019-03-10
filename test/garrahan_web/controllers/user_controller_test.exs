defmodule GarrahanWeb.UserControllerTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.Accounts.{User, ActivationToken, RecoverToken}

  import GarrahanWeb.AuthCase

  @update_attrs %{password: "some updated password", is_admin: true}
  @invalid_attrs %{password: nil}

  setup %{conn: conn, admin: admin} do
    {:ok, conn: auth_user(conn, admin)}
  end

  describe "index" do
    test_auth_admin_required(fn conn, _params ->
      get(conn, Routes.user_path(conn, :index))
    end)

    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert [%{}, %{}] = json_response(conn, 200)["data"]
    end
  end

  describe "create user" do
    test "can't create users directly - endpoint doesn't exist", %{conn: conn} do
      assert_error_sent 404, fn ->
        post(conn, Routes.user_path(conn, :index) <> "/create", user: %{})
      end
    end
  end

  describe "update user" do
    test_auth_admin_required(fn conn, %{user: user} ->
      put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
    end)

    test "renders user when data is valid", %{
      conn: conn,
      user: %User{id: id} = user,
      surgeon: surgeon
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => user.id,
               "disabled" => user.disabled,
               "isAdmin" => @update_attrs.is_admin,
               "surgeonId" => surgeon.id,
               "email" => surgeon.email,
               "firstName" => surgeon.first_name,
               "lastName" => surgeon.last_name,
               "license" => nil
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    test "can't delete users directly - endpoint doesn't exist", %{conn: conn} do
      assert_error_sent 404, fn ->
        delete(conn, Routes.user_path(conn, :index) <> "/delete")
      end
    end
  end

  describe "recover user (POST)" do
    test "renders surgeron when email is valid", %{conn: conn, surgeon: surgeon} do
      data = %{"email" => surgeon.email}

      conn = post(conn, Routes.user_path(conn, :recover), data)

      assert %{
               "id" => surgeon.id,
               "email" => surgeon.email,
               "firstName" => surgeon.first_name,
               "lastName" => surgeon.last_name,
               "license" => surgeon.license
             } == json_response(conn, 200)
    end

    test "renders error 'EMAIL_NOT_EXISTS' if the email was not found", %{conn: conn} do
      data = %{"email" => "nobody@email.com"}

      conn = post(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "EMAIL_NOT_EXISTS", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'WRONG_REQUEST' if request is not valid", %{conn: conn} do
      data = %{"whatever" => "something"}

      conn = post(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "WRONG_REQUEST", "status" => "error"} == json_response(conn, 400)
    end
  end

  describe "recover user (GET)" do
    test "renders surgeon when token is valid", %{conn: conn, surgeon: surgeon} do
      data = %{"token" => RecoverToken.generate(surgeon.email)}

      conn = get(conn, Routes.user_path(conn, :recover), data)

      assert %{
               "id" => surgeon.id,
               "email" => surgeon.email,
               "firstName" => surgeon.first_name,
               "lastName" => surgeon.last_name,
               "license" => surgeon.license
             } == json_response(conn, 200)
    end

    test "renders error 'WRONG_TOKEN' if the surgeon was not found", %{
      conn: conn,
      surgeon: surgeon
    } do
      data = %{"token" => RecoverToken.generate(surgeon.email)}

      {:ok, _} = Garrahan.Surgeries.delete_surgeon(surgeon)
      conn = get(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "WRONG_TOKEN", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'WRONG_TOKEN' if token is not valid", %{conn: conn} do
      data = %{"token" => "wrong"}

      conn = get(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "WRONG_TOKEN", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'WRONG_REQUEST' if request is not valid", %{conn: conn} do
      data = %{"whatever" => "something"}

      conn = get(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "WRONG_REQUEST", "status" => "error"} == json_response(conn, 400)
    end
  end

  describe "recover user (PUT)" do
    test "renders surgeon when recovery data is valid", %{conn: conn, surgeon: surgeon} do
      data = %{
        "token" => RecoverToken.generate(surgeon.email),
        "password" => "asdasd",
        "confirm" => "asdasd"
      }

      conn = put(conn, Routes.user_path(conn, :recover), data)

      assert %{
               "id" => surgeon.id,
               "email" => surgeon.email,
               "firstName" => surgeon.first_name,
               "lastName" => surgeon.last_name,
               "license" => surgeon.license
             } == json_response(conn, 200)
    end

    test "renders error 'WRONG_TOKEN' if the surgeon was not found", %{
      conn: conn,
      surgeon: surgeon
    } do
      data = %{
        "token" => RecoverToken.generate(surgeon.email),
        "password" => "asdasd",
        "confirm" => "asdasd"
      }

      {:ok, _} = Garrahan.Surgeries.delete_surgeon(surgeon)
      conn = put(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "WRONG_TOKEN", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'WRONG_TOKEN' if token is not valid", %{conn: conn} do
      data = %{
        "token" => "wrong",
        "password" => "asdasd",
        "confirm" => "asdasd"
      }

      conn = put(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "WRONG_TOKEN", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'PASSWORD_MISMATCH' if password and confirm don't match", %{
      conn: conn,
      surgeon: surgeon
    } do
      data = %{
        "token" => RecoverToken.generate(surgeon.email),
        "password" => "asdasd",
        "confirm" => "qweqwe"
      }

      conn = put(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "PASSWORD_MISMATCH", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'PASSWORD_WEAK' if password doesn't match the minimum requirements", %{
      conn: conn,
      surgeon: surgeon
    } do
      data = %{
        "token" => RecoverToken.generate(surgeon.email),
        "password" => "asd",
        "confirm" => "asd"
      }

      conn = put(conn, Routes.user_path(conn, :recover), data)

      assert %{"code" => "PASSWORD_WEAK", "status" => "error"} == json_response(conn, 400)
    end
  end

  describe "activate user (GET)" do
    test "renders user when token and user are valid", %{conn: conn} do
      {%{password_hash: nil} = user, surgeon} = fixture_activate_user()

      data = %{"token" => ActivationToken.generate(user)}

      conn = get(conn, Routes.user_path(conn, :activate), data)

      assert %{
               "id" => user.id,
               "disabled" => user.disabled,
               "isAdmin" => user.is_admin,
               "surgeonId" => surgeon.id,
               "email" => surgeon.email,
               "firstName" => surgeon.first_name,
               "lastName" => surgeon.last_name,
               "license" => surgeon.license
             } == json_response(conn, 200)["data"]
    end

    test "renders error 'WRONG_TOKEN' if the user was not found", %{
      conn: conn,
      user: user,
      surgeon: surgeon
    } do
      data = %{"token" => ActivationToken.generate(user)}

      {:ok, _} = Garrahan.Surgeries.delete_surgeon(surgeon)
      conn = get(conn, Routes.user_path(conn, :activate), data)

      assert %{"code" => "WRONG_TOKEN", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'WRONG_TOKEN' if token is not valid", %{conn: conn} do
      data = %{"token" => "wrong"}

      conn = get(conn, Routes.user_path(conn, :activate), data)

      assert %{"code" => "WRONG_TOKEN", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'ALREADY_ACTIVATED' if the user was already activated", %{
      conn: conn,
      user: user
    } do
      data = %{"token" => ActivationToken.generate(user)}

      conn = get(conn, Routes.user_path(conn, :activate), data)

      assert %{"code" => "ALREADY_ACTIVATED", "status" => "error"} == json_response(conn, 400)
    end
  end

  describe "activate user (PUT)" do
    test "renders user when activation data and user are valid", %{conn: conn} do
      {%{password_hash: nil} = user, surgeon} = fixture_activate_user()

      data = %{
        "token" => ActivationToken.generate(user),
        "password" => "asdasd",
        "confirm" => "asdasd"
      }

      conn = put(conn, Routes.user_path(conn, :activate), data)

      assert %{
               "id" => user.id,
               "disabled" => user.disabled,
               "isAdmin" => user.is_admin,
               "surgeonId" => surgeon.id,
               "email" => surgeon.email,
               "firstName" => surgeon.first_name,
               "lastName" => surgeon.last_name,
               "license" => surgeon.license
             } == json_response(conn, 200)["data"]

      user = Garrahan.Accounts.get_user!(user.id)
      assert user.password_hash != nil && is_binary(user.password_hash)
    end

    test "renders error 'WRONG_TOKEN' if the user was not found", %{
      conn: conn,
      user: user,
      surgeon: surgeon
    } do
      data = %{
        "token" => ActivationToken.generate(user),
        "password" => "asdasd",
        "confirm" => "asdasd"
      }

      {:ok, _} = Garrahan.Surgeries.delete_surgeon(surgeon)
      conn = put(conn, Routes.user_path(conn, :activate), data)

      assert %{"code" => "WRONG_TOKEN", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'WRONG_TOKEN' if token is not valid", %{conn: conn} do
      data = %{
        "token" => "wrong",
        "password" => "asdasd",
        "confirm" => "asdasd"
      }

      conn = put(conn, Routes.user_path(conn, :activate), data)

      assert %{"code" => "WRONG_TOKEN", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'PASSWORD_MISMATCH' if password and confirm don't match", %{conn: conn} do
      {user, _} = fixture_activate_user()

      data = %{
        "token" => ActivationToken.generate(user),
        "password" => "asdasd",
        "confirm" => "qweqwe"
      }

      conn = put(conn, Routes.user_path(conn, :activate), data)

      assert %{"code" => "PASSWORD_MISMATCH", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'PASSWORD_WEAK' if password doesn't match the minimum requirements", %{
      conn: conn
    } do
      {user, _} = fixture_activate_user()

      data = %{
        "token" => ActivationToken.generate(user),
        "password" => "asd",
        "confirm" => "asd"
      }

      conn = put(conn, Routes.user_path(conn, :activate), data)

      assert %{"code" => "PASSWORD_WEAK", "status" => "error"} == json_response(conn, 400)
    end

    test "renders error 'ALREADY_ACTIVATED' if the user was already activated", %{
      conn: conn,
      user: user
    } do
      data = %{
        "token" => ActivationToken.generate(user),
        "password" => "asdasd",
        "confirm" => "asdasd"
      }

      conn = put(conn, Routes.user_path(conn, :activate), data)

      assert %{"code" => "ALREADY_ACTIVATED", "status" => "error"} == json_response(conn, 400)
    end
  end

  defp fixture_activate_user() do
    {:ok, user} = Garrahan.Accounts.create_user(%{is_admin: false})

    {:ok, surgeon} =
      Garrahan.Surgeries.create_surgeon(
        %{
          email: "activate@test.com",
          first_name: "Fiqus",
          last_name: "User"
        },
        user
      )

    {user, surgeon}
  end
end
