defmodule MyWorker do
  alias Porcelain.Process, as: Proc

  def perform do
    Task.start(fn ->
      proc =
        %Proc{pid: pid} =
        Porcelain.spawn_shell("tail -f /Users/ricardo.paiva/foo.bar",
          out: {:send, self()}
        )

      out(pid, proc)
    end)
  end

  def out(pid, proc) do
    data =
      receive do
        {^pid, :data, :out, data} ->
          IO.puts("--------> DATA do PID (#{inspect(pid)}): \n #{data}")
          data

        _ ->
          IO.puts("---------> CACETE DE AGULHA")
      end

    if Proc.alive?(proc) do
      IO.puts("-----> ESTOU ALIVE")
      out(pid, proc)
    else
      IO.puts("-----> MORRI")
    end
  end
end
