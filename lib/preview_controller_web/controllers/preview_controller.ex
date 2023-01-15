defmodule PreviewControllerWeb.PreviewController do
  use PreviewControllerWeb, :controller

  alias PreviewController.Environments
  alias PreviewController.Environments.Preview

  def index(conn, _params) do
    previews = Environments.list_previews()
    render(conn, :index, previews: previews)
  end

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"name" => name, "tag" => tag}) do
    preview = %Preview{
      id: name,
      name: name,
      tag: tag,
      url: "#{name}.preview.immich.cloud"
    }

    conn =
      case Environments.create(preview) do
        {:ok, _} -> put_flash(conn, :info, "Environment #{name} deployed successfully.")
        {:error, err} -> put_flash(conn, :error, err.message)
      end

    redirect(conn, to: ~p"/")
  end

  def edit(conn, %{"id" => id}) do
    preview = Environments.get_preview!(id)
    render(conn, :edit, preview: preview)
  end

  def update(conn, %{"id" => id, "tag" => tag} = args) do
    :ok = Environments.update_tag(id, tag)

    conn
    |> put_flash(:info, "Environment #{id} updated successfully.")
    |> redirect(to: ~p"/")
  end

  def delete(conn, %{"id" => id}) do
    {:ok, preview} = Environments.delete(id)

    conn
    |> put_flash(:info, "Environment #{preview.id} deleted successfully.")
    |> redirect(to: ~p"/")
  end
end
