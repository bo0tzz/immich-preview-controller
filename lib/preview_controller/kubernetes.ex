defmodule PreviewController.Kubernetes do
  def conn() do
    Application.fetch_env!(:preview_controller, __MODULE__)[:conn]
  end

  def get_all() do
    op =
      K8s.Client.list("helm.toolkit.fluxcd.io/v2beta1", "HelmRelease")
      |> K8s.Selector.label({"preview.immich.app/managed", "true"})

    {:ok, %{"items" => helm_releases}} = K8s.Client.run(conn(), op)

    helm_releases
  end

  def get(name) do
    op =
      K8s.Client.list("helm.toolkit.fluxcd.io/v2beta1", "HelmRelease")
      |> K8s.Selector.label({"preview.immich.app/managed", "true"})
      |> K8s.Selector.field({"metadata.name", name})

    case K8s.Client.run(conn(), op) do
      {:ok, %{"items" => [release]}} -> {:ok, release}
      {:ok, %{"items" => []}} -> {:error, :not_found}
    end
  end

  def delete(id) do
    with {:ok, release} <- get(id),
         op <- K8s.Client.delete(release) do
      K8s.Client.run(conn(), op)
    end
  end

  def deploy(manifest) do
    op = K8s.Client.create(manifest)
    K8s.Client.run(conn(), op)
  end

  def new_manifest(name, tag, url) do
    %{
      "apiVersion" => "helm.toolkit.fluxcd.io/v2beta1",
      "kind" => "HelmRelease",
      "metadata" => %{
        "labels" => %{
          "preview.immich.app/managed" => "true"
        },
        "name" => name,
        "namespace" => "previews"
      },
      "spec" => %{
        "chart" => %{
          "spec" => %{
            "chart" => "helm/immich-preview",
            "interval" => "1m",
            "reconcileStrategy" => "ChartVersion",
            "sourceRef" => %{
              "kind" => "GitRepository",
              "name" => "immich-preview-charts",
              "namespace" => "flux-system"
            },
            "version" => "0.1.5"
          }
        },
        "interval" => "15m",
        "values" => %{
          "loginPageMessage" =>
            "This is a preview of the Immich tag #{tag}.<br>\nEmail: <i>demo@immich.app</i><br>Password: <i>demo</i>",
          "suspend" => false,
          "tag" => tag,
          "url" => url
        }
      }
    }
  end
end
