defmodule Dafs.FileController do
  use Dafs.Web, :controller

  alias Dafs.DFile

  def index(conn, _params) do
    users = Repo.all(Dafs.User)
    render(conn, "index.html", users: users)
  end
end
