defmodule LiveDexWeb.HomeLive.Index do
  use Phoenix.LiveView

  alias LiveDex.Pokemon
  alias LiveDexWeb.Components

  def mount(_params, _, socket) do
    start_time = :erlang.monotonic_time()
    {:ok, pokemon} = Pokemon.get_pokemon(1, true)
    end_time = :erlang.monotonic_time()

    {:ok,
     socket
     |> assign(:pokemon, pokemon)
     |> assign(:error, "")
     |> assign(:use_cache, true)
     |> assign(
       :search_time,
       :erlang.convert_time_unit(end_time - start_time, :native, :millisecond)
     )
     |> assign(:search_param, "")}
  end

  def handle_event("search", %{"param" => param}, socket) do
    get_pokemon(param, socket)

    if String.match?(param, ~r/^\d+$/) do
      {id, _} = Integer.parse(param)

      get_pokemon(id, socket)
    else
      get_pokemon(param, socket)
    end
  end

  def handle_event("prev", _param, socket) do
    pokemon_id =
      socket.assigns.pokemon.id

    get_pokemon(pokemon_id - 1, socket)
  end

  def handle_event("next", _param, socket) do
    pokemon_id =
      socket.assigns.pokemon.id

    get_pokemon(pokemon_id + 1, socket)
  end

  def handle_event("toggle_cache", _params, socket) do
    {:noreply,
     socket
     |> assign(
       :use_cache,
       !socket.assigns.use_cache
     )}
  end

  defp get_pokemon(param, socket) do
    start_time = :erlang.monotonic_time()

    with {:ok, pokemon} <- Pokemon.get_pokemon(param, socket.assigns.use_cache) do
      end_time = :erlang.monotonic_time()

      {:noreply,
       socket
       |> assign(:pokemon, pokemon)
       |> assign(
         :search_time,
         :erlang.convert_time_unit(end_time - start_time, :native, :millisecond)
       )}
    else
      {:error, _} ->
        {:noreply,
         socket
         |> assign(:error, "Pokemon not found!")
         |> assign(:pokemon, nil)}
    end
  end
end
