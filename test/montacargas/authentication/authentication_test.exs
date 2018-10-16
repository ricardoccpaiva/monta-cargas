defmodule Montacargas.AuthenticationTest do
  use Montacargas.DataCase

  alias Montacargas.Authentication

  describe "login" do
    alias Montacargas.Authentication.Login

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def login_fixture(attrs \\ %{}) do
      {:ok, login} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authentication.create_login()

      login
    end

    test "list_login/0 returns all login" do
      login = login_fixture()
      assert Authentication.list_login() == [login]
    end

    test "get_login!/1 returns the login with given id" do
      login = login_fixture()
      assert Authentication.get_login!(login.id) == login
    end

    test "create_login/1 with valid data creates a login" do
      assert {:ok, %Login{} = login} = Authentication.create_login(@valid_attrs)
    end

    test "create_login/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_login(@invalid_attrs)
    end

    test "update_login/2 with valid data updates the login" do
      login = login_fixture()
      assert {:ok, login} = Authentication.update_login(login, @update_attrs)
      assert %Login{} = login
    end

    test "update_login/2 with invalid data returns error changeset" do
      login = login_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.update_login(login, @invalid_attrs)
      assert login == Authentication.get_login!(login.id)
    end

    test "delete_login/1 deletes the login" do
      login = login_fixture()
      assert {:ok, %Login{}} = Authentication.delete_login(login)
      assert_raise Ecto.NoResultsError, fn -> Authentication.get_login!(login.id) end
    end

    test "change_login/1 returns a login changeset" do
      login = login_fixture()
      assert %Ecto.Changeset{} = Authentication.change_login(login)
    end
  end
end
