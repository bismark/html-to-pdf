defmodule HtmlToPdf.WebSocket do

  @callback init_socket(map) :: {:ok, URI.t, map} | {:error, atom}
  @callback handle_message(term, Socket.Web.t, state :: map) :: {:ok, map}
  @callback handle_call(term, GenServer.from, Socket.Web.t, map) :: {:reply, term, map} | {:noreply, map}

  defmacro __using__(_) do
    quote do
      use GenServer
      @behaviour HtmlToPdf.WebSocket

      alias __MODULE__, as: This
      alias HtmlToPdf.WebSocketReceiver

      def start_link(args) do
        GenServer.start_link(This, args)
      end


      @impl true
      def init(args) do
        with {:ok, uri, internal_state} <- init_socket(args),
             {:ok, socket} <- Socket.Web.connect(uri.host, uri.port, path: uri.path)
        do
          WebSocketReceiver.start_link(socket)
          {:ok, %{socket: socket, internal_state: internal_state}}
        end
      end


      @impl true
      def handle_call(request, from, state) do
        case handle_call(request, from, state[:socket], state[:internal_state]) do
          {:reply, reply, internal_state} ->
            {:reply, reply, Map.put(state, :internal_state, internal_state)}
          {:noreply, internal_state} ->
            {:noreply, Map.put(state, :internal_state, internal_state)}
        end
      end


      @impl true
      # not interested in binaries...
      def handle_info({:socket_received, {:binary, _}}, state), do: {:noreply, state}
      def handle_info({:socket_received, {:text, text}}, state) do
        body = Poison.decode!(text)
        {:ok, internal_state} = handle_message(text, state[:socket], state[:internal_state])
        {:noreply, Map.put(state, :internal_state, internal_state)}
      end
    end
  end
end
