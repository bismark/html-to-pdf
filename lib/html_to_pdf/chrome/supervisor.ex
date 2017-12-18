defmodule HtmlToPdf.Chrome.Supervisor do

  require Logger
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end


  def init(_) do
    Logger.info "Starting Chrome worker supervisor"
    _children = [

    ]
  end


end
