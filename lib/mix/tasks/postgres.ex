defmodule Mix.Tasks.Postgres do
  use Mix.Task

  @shortdoc "Start/stops a local postgres docker contaienr"
  def run(args) do
    case args do
      ["stop" | _] ->
        Mix.shell().info("Stopping postgres docker container")
        Mix.Shell.cmd("docker kill dps-postgres", &IO.write(&1))

      ["start" | _] ->
        Mix.shell().info("Starting postgres docker container")

        Mix.Shell.cmd(
          "docker run --rm --name dps-postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres",
          &IO.write(&1)
        )

      _ ->
        Mix.shell().error("Please pass either the 'start' or 'stop' command")
    end
  end
end
