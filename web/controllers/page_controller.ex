defmodule Dafs.PageController do
  use Dafs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
