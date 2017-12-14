defmodule HtmlToPdf.Worker do
  use GenServer

  alias __MODULE__, as: This

  @server_path Path.expand("../../priv/bin/server", "#{__DIR__}")
  # Expected Errors
  _ = [:bad_input, :conversion_failed]

  def start_link(_) do
    GenServer.start_link(This, [])
  end

  @impl true
  def init(_) do
    server_options = %{pty: true, stdin: true, stdout: true, stderr: true}
    {:ok, server_pid, server_os_pid} = Exexec.run_link(@server_path, server_options)
    {:ok, {server_pid, server_os_pid}}
  end

  @impl true
  def handle_call({:convert, from_path, to_path}, _, state = {server_pid, server_os_pid}) do
    Exexec.send server_pid, "#{from_path} #{to_path}\n"
    receive do
      {:stderr, ^server_os_pid, "ERROR" <> message} ->
        {:reply, {:error, format_error(message)}, state}
      {:stdout, ^server_os_pid, "ERROR" <> message} ->
        {:reply, {:error, format_error(message)}, state}
      {:stdout, ^server_os_pid, "OK" <> _} ->
        {:reply, :ok, state}
    end
  end

  defp format_error(message) do
    message
      |> String.trim
      |> String.to_existing_atom
  end

end

