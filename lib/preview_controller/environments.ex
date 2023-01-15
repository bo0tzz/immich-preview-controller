defmodule PreviewController.Environments do
  @moduledoc """
  The Environments context.
  """

  # import Ecto.Query, warn: false
  # alias PreviewController.Repo

  alias PreviewController.Environments.Preview
  alias PreviewController.Kubernetes

  def resource_to_preview(resource) do
    # TODO: Get status from manifest
    # When initializing:
    # status:
    #   conditions:
    #     - lastTransitionTime: '2023-01-14T16:54:42Z'
    #       message: Reconciliation in progress
    #       reason: Progressing
    #       status: Unknown
    #       type: Ready
    # When done:
    # status:
    #   conditions:
    #     - lastTransitionTime: '2023-01-14T16:55:39Z'
    #       message: Release reconciliation succeeded
    #       reason: ReconciliationSucceeded
    #       status: 'True'
    #       type: Ready
    #     - lastTransitionTime: '2023-01-14T16:55:39Z'
    #       message: Helm install succeeded
    #       reason: InstallSucceeded
    #       status: 'True'
    #       type: Released
    status =
      case resource["spec"]["values"]["suspend"] do
        true -> :suspended
        # TODO
        _ -> :ok
      end

    %Preview{
      status: status,
      name: resource["metadata"]["name"],
      id: resource["metadata"]["name"],
      tag: resource["spec"]["values"]["tag"],
      url: resource["spec"]["values"]["url"]
    }
  end

  @doc """
  Returns the list of previews.

  ## Examples

      iex> list_previews()
      [%Preview{}, ...]

  """
  def list_previews do
    Kubernetes.get_all()
    |> Enum.map(&resource_to_preview/1)
  end

  @doc """
  Gets a single preview.

  Raises `Ecto.NoResultsError` if the Preview does not exist.

  ## Examples

      iex> get_preview!(123)
      %Preview{}

      iex> get_preview!(456)
      ** (Ecto.NoResultsError)

  """
  def get_preview!(id) do
    case Kubernetes.get(id) do
      {:ok, res} -> resource_to_preview(res)
      {:error, :not_found} -> raise PreviewControllerWeb.NotFoundError
    end
  end

  def update_tag(id, tag) do
    IO.puts("Update tag to #{tag} for #{id}")
    :ok
  end

  def create(%Preview{} = p) do
    manifest = Kubernetes.new_manifest(p.name, p.tag, p.url)
    Kubernetes.deploy(manifest)
  end

  def delete(id) do
    with {:ok, res} <- Kubernetes.delete(id) do
      {:ok, resource_to_preview(res)}
    end
  end
end
