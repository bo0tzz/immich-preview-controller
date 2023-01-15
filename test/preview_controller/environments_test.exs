defmodule PreviewController.EnvironmentsTest do
  use PreviewController.DataCase

  alias PreviewController.Environments

  describe "previews" do
    alias PreviewController.Environments.Preview

    import PreviewController.EnvironmentsFixtures

    @invalid_attrs %{name: nil, status: nil, tag: nil, url: nil}

    test "list_previews/0 returns all previews" do
      preview = preview_fixture()
      assert Environments.list_previews() == [preview]
    end

    test "get_preview!/1 returns the preview with given id" do
      preview = preview_fixture()
      assert Environments.get_preview!(preview.id) == preview
    end

    test "create_preview/1 with valid data creates a preview" do
      valid_attrs = %{name: "some name", status: "some status", tag: "some tag", url: "some url"}

      assert {:ok, %Preview{} = preview} = Environments.create_preview(valid_attrs)
      assert preview.name == "some name"
      assert preview.status == "some status"
      assert preview.tag == "some tag"
      assert preview.url == "some url"
    end

    test "create_preview/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Environments.create_preview(@invalid_attrs)
    end

    test "update_preview/2 with valid data updates the preview" do
      preview = preview_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", tag: "some updated tag", url: "some updated url"}

      assert {:ok, %Preview{} = preview} = Environments.update_preview(preview, update_attrs)
      assert preview.name == "some updated name"
      assert preview.status == "some updated status"
      assert preview.tag == "some updated tag"
      assert preview.url == "some updated url"
    end

    test "update_preview/2 with invalid data returns error changeset" do
      preview = preview_fixture()
      assert {:error, %Ecto.Changeset{}} = Environments.update_preview(preview, @invalid_attrs)
      assert preview == Environments.get_preview!(preview.id)
    end

    test "delete_preview/1 deletes the preview" do
      preview = preview_fixture()
      assert {:ok, %Preview{}} = Environments.delete_preview(preview)
      assert_raise Ecto.NoResultsError, fn -> Environments.get_preview!(preview.id) end
    end

    test "change_preview/1 returns a preview changeset" do
      preview = preview_fixture()
      assert %Ecto.Changeset{} = Environments.change_preview(preview)
    end
  end
end
