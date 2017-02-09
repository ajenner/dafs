defmodule Dafs.FileController do
  use Dafs.Web, :controller

  alias Dafs.DFile

  def index(conn, _params) do
    users = Repo.all(DFile)
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = DFile.changeset(%DFile{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"d_file" => file_params}) do
    current_user_id = Coherence.current_user(conn).id
    %{"file" => f} = file_params
    %{size: size} = File.stat! f.path
    file = %{"user_id" => current_user_id,
      "name" => f.filename,
      "size" => size,
      "contents" => File.read!(f.path)
    }

    changeset = DFile.changeset(%DFile{}, file)

    case Repo.insert(changeset) do
      {:ok, _file} ->
        conn
        |> put_flash(:info, "File created successfully.")
        |> redirect(to: file_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
