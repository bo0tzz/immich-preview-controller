defmodule PreviewControllerWeb.PreviewControllerTest do
  use PreviewControllerWeb.ConnCase

  import PreviewController.EnvironmentsFixtures

  @create_attrs %{name: "some name", status: "some status", tag: "some tag", url: "some url"}
  @update_attrs %{name: "some updated name", status: "some updated status", tag: "some updated tag", url: "some updated url"}
  @invalid_attrs %{name: nil, status: nil, tag: nil, url: nil}

  describe "index" do
    test "lists all previews", %{conn: conn} do
      conn = get(conn, ~p"/previews")
      assert html_response(conn, 200) =~ "Listing Previews"
    end
  end

  describe "new preview" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/previews/new")
      assert html_response(conn, 200) =~ "New Preview"
    end
  end

  describe "create preview" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/previews", preview: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/previews/#{id}"

      conn = get(conn, ~p"/previews/#{id}")
      assert html_response(conn, 200) =~ "Preview #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/previews", preview: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Preview"
    end
  end

  describe "edit preview" do
    setup [:create_preview]

    test "renders form for editing chosen preview", %{conn: conn, preview: preview} do
      conn = get(conn, ~p"/previews/#{preview}/edit")
      assert html_response(conn, 200) =~ "Edit Preview"
    end
  end

  describe "update preview" do
    setup [:create_preview]

    test "redirects when data is valid", %{conn: conn, preview: preview} do
      conn = put(conn, ~p"/previews/#{preview}", preview: @update_attrs)
      assert redirected_to(conn) == ~p"/previews/#{preview}"

      conn = get(conn, ~p"/previews/#{preview}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, preview: preview} do
      conn = put(conn, ~p"/previews/#{preview}", preview: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Preview"
    end
  end

  describe "delete preview" do
    setup [:create_preview]

    test "deletes chosen preview", %{conn: conn, preview: preview} do
      conn = delete(conn, ~p"/previews/#{preview}")
      assert redirected_to(conn) == ~p"/previews"

      assert_error_sent 404, fn ->
        get(conn, ~p"/previews/#{preview}")
      end
    end
  end

  defp create_preview(_) do
    preview = preview_fixture()
    %{preview: preview}
  end
end
