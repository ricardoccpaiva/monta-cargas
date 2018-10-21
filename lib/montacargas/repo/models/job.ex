defmodule MontaCargas.Repo.Models.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field(:description, :string)
    field(:name, :string)
    field(:inserted_by, :string)
    field(:updated_by, :string)
    field(:status, :string)
    field(:test_plan, :string)

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :description, :test_plan])
    |> validate_required([:name, :description, :test_plan])
  end
end
