defmodule HtmlToPdf.Pool do

  alias __MODULE__, as: This

  def child_spec(_) do
    config = [
      name: {:local, This},
      worker_module: HtmlToPdf.Worker,
      size: 2,
      max_overflow: 1,
    ]
   :poolboy.child_spec(This, config, [])
  end


  def convert(from_path, to_path) do
    :poolboy.transaction(This, fn worker ->
      GenServer.call(worker, {:convert, from_path, to_path}, 10000)
    end)
  end


end
