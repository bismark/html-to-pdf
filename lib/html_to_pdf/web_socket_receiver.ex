defmodule HtmlToPdf.WebSocketReceiver do
  defmodule Fragment do
    defstruct [
      :type,
      :data
    ]
  end

  def start_link(socket) do
    pid = spawn_link(__MODULE__, :listen, [socket, self(), nil])
    {:ok, pid}
  end

  def listen(socket, owner, fragment) do
    case Socket.Web.recv!(socket) do
      {:ping, _} ->
        Socket.Web.send!(socket, {:pong, ""})
        listen(socket, owner, fragment)

      {:pong, _} ->
        listen(socket, owner, fragment)

      {:fragmented, step, _} when step in [:continuation, :end] and is_nil(fragment) ->
        # Bad fragment, throw away
        listen(socket, owner, fragment)

      {:fragmented, :continuation, data} ->
        fragment = %Fragment{fragment | data: fragment.data <> data}
        listen(socket, owner, fragment)

      {:fragmented, :end, data} ->
        data = fragment.data <> data
        send(owner, {:socket_received, {fragment.type, data}})
        listen(socket, owner, nil)

      {:fragmented, type, data} ->
        listen(socket, owner, %Fragment{type: type, data: data})

      :close ->
        exit(:closed)

      {:close, _, _} ->
        exit(:closed)

      {type, data} ->
        send(owner, {:socked_received, {type, data}})
        listen(socket, owner, nil)
    end
  end
end
