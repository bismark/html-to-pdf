defmodule HtmlToPdf.Chrome.RootSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      HtmlToPdf.Chrome.Chrome,
      HtmlToPdf.Chrome.Browser
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
