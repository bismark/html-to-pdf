defmodule HtmlToPdf.Chrome.Browser do
  use HtmlToPdf.WebSocket

  alias __MODULE__, as: This

  @debugger_address "http://localhost:9222/json"
  require Logger

  defstruct targets: %{}

  def print_page(from_path, to_path) do
    {:ok, pdf} = GenServer.call(This, {:print_pdf, from_path})
    {:ok, file} = File.open(to_path, [:raw, :write])
    :ok = IO.write(file, pdf)
    File.close(file)
    :ok
  end

  @impl true
  def init_socket(_args) do
    ws_url =
      fetch_ws_url()
      |> URI.parse()

    {:ok, ws_url, This}
  end

  @impl true
  def handle_call(_, _, _, _) do
    # def handle_call({:print_pdf, from_path}, from, socket, state) do
  end

  @impl true
  def handle_message(message, _socket, state) do
    Logger.error(inspect(message))
    {:ok, state}
  end

  defp fetch_ws_url do
    res = HTTPoison.get(@debugger_address)

    case res do
      {:error, %HTTPoison.Error{reason: :econnrefused}} ->
        # Chrome is still booting, let's sleep and retry
        Logger.info("Waiting for Chrome to boot")
        Process.sleep(1000)
        fetch_ws_url()

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        [body] = Poison.decode!(body)
        body["webSocketDebuggerUrl"]
    end
  end
end
