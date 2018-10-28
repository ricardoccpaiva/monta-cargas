defmodule MontaCargas.Repo.Migrations.CreateJobs do
  use Ecto.Migration
   def change do
    create table(:jobs) do
      add(:name, :string)
      add(:description, :string)
      add(:inserted_by, :string)
      add(:updated_by, :string, null: true)
      add(:status, :string)
      add(:test_plan, :string)
       timestamps()
    end
  end
end