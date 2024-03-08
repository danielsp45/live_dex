defmodule LiveDexWeb.HomeLive.Index do
  use Phoenix.LiveView

  alias LiveDex.Pokemon

  def mount(_params, _, socket) do
    {:ok, pokemon} = Pokemon.get_pokemon("1")

    {:ok,
     socket
     |> assign(:pokemon, pokemon)
     |> assign(:error, nil)
     |> assign(:search_param, "")}
  end

  def handle_event("search", %{"param" => param}, socket) do
    with {:ok, pokemon} <- Pokemon.get_pokemon(param) do
      {:noreply, assign(socket, :pokemon, pokemon)}
    else
      {:error, _} ->
        {:noreply,
         socket
         |> assign(:error, "Pokemon not found!")
         |> assign(:pokemon, nil)}
    end
  end

  def handle_event("prev", _param, socket) do
    pokemon_id =
      socket.assigns.pokemon.id

    with {:ok, pokemon} <- Pokemon.get_pokemon(Integer.to_string(pokemon_id - 1)) do
      {:noreply, assign(socket, :pokemon, pokemon)}
    else
      {:error, _} ->
        {:noreply,
         socket
         |> assign(:error, "Previous pokemon found!")
         |> assign(:pokemon, nil)}
    end
  end

  def handle_event("next", _param, socket) do
    pokemon_id =
      socket.assigns.pokemon.id

    with {:ok, pokemon} <- Pokemon.get_pokemon(Integer.to_string(pokemon_id + 1)) do
      {:noreply, assign(socket, :pokemon, pokemon)}
    else
      {:error, _} ->
        {:noreply,
         socket
         |> assign(:error, "Following pokemon found!")
         |> assign(:pokemon, nil)}
    end
  end
end
