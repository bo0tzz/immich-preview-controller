defmodule PreviewController.EnvironmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PreviewController.Environments` context.
  """

  @doc """
  Generate a preview.
  """
  def preview_fixture(attrs \\ %{}) do
    {:ok, preview} =
      attrs
      |> Enum.into(%{

      })
      |> PreviewController.Environments.create_preview()

    preview
  end

  @doc """
  Generate a preview.
  """
  def preview_fixture(attrs \\ %{}) do
    {:ok, preview} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status",
        tag: "some tag",
        url: "some url"
      })
      |> PreviewController.Environments.create_preview()

    preview
  end
end
