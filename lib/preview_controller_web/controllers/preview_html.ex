defmodule PreviewControllerWeb.PreviewHTML do
  use PreviewControllerWeb, :html
  import Phoenix.HTML.Link

  embed_templates("preview_html/*")
end
