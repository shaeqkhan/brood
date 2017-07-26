defmodule BroodAccountTest do
  use ExUnit.Case
  use Plug.Test
  require Logger
  alias Brood.Resource.Account
  doctest Brood

  @location_name "CRT Labs"
  @email "test@test.com"
  @password "123456é$@_''"
  @kit_id "596500cf024b160a70a4ea72"
  @zipcode "60626"
  @params %{"location_name" => @location_name, "email" => @email, "password" => @password, "password_conf" => @password, "kit_id" => @kit_id, "zipcode" => @zipcode}

  setup(_context) do
    Logger.debug "Clearing test user"
    @params
    |> Account.parse_params()
    |> Account.find_user()
    |> Account.delete()
    :ok
  end

  test "registration" do
    conn = conn(:put, "/account/register", @params) |> put_req_header("content-type", "multipart/form-data")
    result = Brood.HTTPRouter.call(conn, [])
    assert result.status == 200
  end

  test "email_taken" do
    conn = conn(:put, "/account/register", @params) |> put_req_header("content-type", "multipart/form-data")
    try do
      Brood.HTTPRouter.call(conn, [])
    rescue
      clause in CaseClauseError -> assert true
    end
  end

  test "login" do
    conn = conn(:put, "/account/register", @params) |> put_req_header("content-type", "multipart/form-data")
    result = Brood.HTTPRouter.call(conn, [])
    conn2 = conn(:post, "/account/login", %{"email": @email, "password": @password}) |> put_req_header("content-type", "multipart/form-data")
    result2 = Brood.HTTPRouter.call(conn2, [])
    assert result2.status == 200
  end
end
