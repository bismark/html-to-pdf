defmodule HtmlToPdf.Chrome.Chrome do
  @command [
    "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome",
    "--headless",
    "--disable-gpu",
    "--remote-debugging-port=9222",
    "--disable-javascript"
  ]

  use GenServer
  alias __MODULE__, as: This

  def start_link(_) do
    GenServer.start_link(This, [])
  end

  @impl true
  def init(_) do
    Exexec.run_link(@command)
    {:ok, %{}}
  end
end
