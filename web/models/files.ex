defmodule Dafs.DFile do
  use Dafs.Web, :model

  schema "files" do
    field :path, :string
    field :name, :string
    field :size, :integer
    field :contents, :binary
    belongs_to :user, Dafs.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:path, :name, :size, :contents, :user_id])
    |> validate_required([:path, :name, :size, :contents, :user_id])
  end
end
