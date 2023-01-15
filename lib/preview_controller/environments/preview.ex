defmodule PreviewController.Environments.Preview do
  # use Ecto.Schema
  # import Ecto.Changeset

  defstruct [
    :status,
    :tag,
    :url,
    :name,
    :id,
    :components
  ]

  @doc false
  def changeset(preview, attrs) do
    preview
  end
end
