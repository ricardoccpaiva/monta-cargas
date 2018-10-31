defmodule MontaCargasWeb.JobController do
  use MontaCargasWeb, :controller

  alias MontaCargas.Repo.Models.Job
  alias MontaCargas.Repo.Jobs

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    IO.inspect("---------> #{inspect(jobs)}")
    render(conn, "index.html", jobs: jobs, current_user: get_session(conn, :current_user))
  end

  def new(conn, _params) do
    changeset = Jobs.change_job(%Job{})

    render(conn, "new.html",
      changeset: changeset,
      current_user: get_session(conn, :current_user),
      job: nil
    )
  end

  def create(conn, %{"job" => job_params}) do
    IO.inspect("JOB PARAMS---------> #{inspect(job_params)}")

    if upload = job_params["test_plan_file"] do
      job_params = Map.put(job_params, "test_plan", UUID.uuid4())
      IO.inspect("UPDATED JOB PARAMS---------> #{inspect(job_params)}")
    end

    case Jobs.create_job(job_params) do
      {:ok, job} ->
        if upload = job_params["test_plan_file"] do
          extension = Path.extname(upload.filename)
          File.cp(upload.path, "#{System.cwd()}/test_plans/#{job.test_plan}#{extension}")
        end

        conn
        |> put_flash(:info, "Job created successfully.")
        |> redirect(to: job_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          current_user: get_session(conn, :current_user),
          job: nil
        )
    end
  end

  def show(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    render(conn, "show.html", job: job)
  end

  def edit(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    changeset = Jobs.change_job(job)

    if File.exists?("#{System.cwd()}/test_plans/#{job.id}.pdf") do
      # job.test_plan = "cenas"
    end

    render(conn, "edit.html",
      job: job,
      changeset: changeset,
      current_user: get_session(conn, :current_user)
    )
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    if upload = job_params["test_plan_file"] do
      job_params = Map.put(job_params, "test_plan", UUID.uuid4())
      IO.inspect("UPDATED JOB PARAMS---------> #{inspect(job_params)}")
    end

    job = Jobs.get_job!(id)

    case Jobs.update_job(job, job_params) do
      {:ok, job} ->
        if upload = job_params["test_plan_file"] do
          extension = Path.extname(upload.filename)
          File.cp(upload.path, "#{System.cwd()}/test_plans/#{job.test_plan}#{extension}")
        end

        conn
        |> put_flash(:info, "Job updated successfully.")
        |> redirect(to: job_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          job: job,
          changeset: changeset,
          current_user: get_session(conn, :current_user)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    {:ok, _job} = Jobs.delete_job(job)

    conn
    |> put_flash(:info, "Job deleted successfully.")
    |> redirect(to: job_path(conn, :index))
  end
end
