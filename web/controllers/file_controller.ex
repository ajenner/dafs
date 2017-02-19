defmodule Dafs.FileController do
  use Dafs.Web, :controller

  alias Dafs.DFile

  def index(conn, _params) do
    current_user_id = Coherence.current_user(conn).id
    user_files = Repo.all(from f in DFile, where: f.user_id == ^current_user_id)
    render(conn, "index.html", files: user_files)
  end

  def new(conn, _params) do
    changeset = DFile.changeset(%DFile{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"d_file" => file_params}) do
    current_user_id = Coherence.current_user(conn).id
    %{"file" => f} = file_params
    %{size: size} = File.stat! f.path
    IO.puts(f.path)
    file = %{"path" => f.path,
      "name" => f.filename,
      "size" => size,
      "contents" => File.read!(f.path),
      "user_id" => current_user_id
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

  def show(conn, %{"id" => id}) do
    current_user_id = Coherence.current_user(conn).id
    file = Repo.get!(DFile, id)
    case file.user_id do
      ^current_user_id ->
        contents = file.contents
        conn
        |> put_resp_content_type("application/octet-stream", nil)
        |> put_resp_header("content-disposition", ~s[attachment; filename="#{file.name}"])
        |> send_resp(200, contents)
      _ ->
        conn
        |> redirect(to: file_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    file = Repo.get!(DFile, id)
    changeset = DFile.changeset(file)
    render(conn, "edit.html", file: file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "d_file" => file_params}) do
    file = Repo.get!(DFile, id)
    changeset = DFile.changeset(file, file_params)

    case Repo.update(changeset) do
      {:ok, _file} ->
        conn
        |> put_flash(:info, "File updated successfully.")
        |> redirect(to: file_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", file: file, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Repo.get!(DFile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(file)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: file_path(conn, :index))
  end


end
