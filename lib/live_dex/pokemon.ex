defmodule LiveDex.Pokemon do
  defstruct [:name, :id, :stats, :sprite]

  @api_url Application.compile_env(:live_dex, :api_url)
  @cache Application.compile_env(:live_dex, :cache_name)

  @spec get_pokemon(String.t() | integer(), boolean()) ::
          {:ok, %LiveDex.Pokemon{}} | {:error, String.t()}
  def get_pokemon(param, use_cache) do
    if use_cache do
      get_pokemon_with_cache(param)
    else
      fetch_pokemon(param, nil, false)
    end
  end

  defp get_pokemon_with_cache(param) do
    case Cachex.get(:live_dex_cache, param) do
      {:ok, nil} ->
        IO.puts("NOT IN CACHE")

        case fetch_pokemon(param, 3600, true) do
          {:ok, pokemon} ->
            spawn(fn -> pre_fetch_pokemons(pokemon.id) end)
            {:ok, pokemon}

          {:error, _} ->
            IO.puts("ERROR")
            {:error, "An error occurred"}
        end

      {:ok, pokemon} ->
        IO.puts("IN CACHE")
        spawn(fn -> pre_fetch_pokemons(pokemon.id) end)
        {:ok, pokemon}

      {:error, _} ->
        IO.puts("ERROR")
        {:error, "An error occurred"}
    end
  end

  @spec fetch_pokemon(String.t() | integer(), integer(), boolean()) ::
          {:ok, %LiveDex.Pokemon{}} | {:error, String.t()}
  def fetch_pokemon(param, ttl, use_cache) when is_binary(param) or is_integer(param) do
    id_or_name =
      case param do
        id when is_integer(id) -> Integer.to_string(id)
        name when is_binary(name) -> String.downcase(name)
      end

    url = @api_url <> "pokemon/" <> id_or_name

    with {:ok, response} <- HTTPoison.get(url),
         {:ok, pokemon} <- extract_data(response) do
      if use_cache do
        put_in_cache(param, pokemon, ttl)
      else
        {:ok, pokemon}
      end
    end
  end

  @spec put_in_cache(String.t() | integer(), %LiveDex.Pokemon{}, integer()) ::
          {:ok, %LiveDex.Pokemon{}} | {:error, term()}
  defp put_in_cache(param, pokemon, ttl) do
    with {:ok, true} <- Cachex.put(@cache, param, pokemon, ttl: ttl) do
      {:ok, pokemon}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp pre_fetch_pokemons(id) do
    if Cachex.get(@cache, id - 1) == {:ok, nil} do
      fetch_pokemon(id - 1, 600, true)
    end

    if Cachex.get(@cache, id + 1) == {:ok, nil} do
      fetch_pokemon(id + 1, 600, true)
    end
  end

  @spec extract_data(HTTPoison.Response.t()) :: {:ok, %LiveDex.Pokemon{}} | {:error, term()}
  defp extract_data(response) do
    with {:ok, body} <- Jason.decode(response.body) do
      {:ok,
       %LiveDex.Pokemon{}
       |> Map.put(:name, extract_name(body))
       |> Map.put(:id, extract_id(body))
       |> Map.put(:stats, extract_stats(body))
       |> Map.put(:sprite, extract_sprite(body))}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec extract_name(map()) :: String.t()
  defp extract_name(body) do
    Map.get(body, "name")
  end

  @spec extract_id(map()) :: String.t()
  defp extract_id(body) do
    Map.get(body, "id")
  end

  @spec extract_stats(map()) :: list({String.t(), String.t()})
  defp extract_stats(body) do
    Enum.map(body["stats"], fn %{"base_stat" => base_stat, "stat" => %{"name" => name}} ->
      {name, base_stat}
    end)
  end

  @spec extract_sprite(map()) :: String.t()
  defp extract_sprite(body) do
    body
    |> Map.get("sprites")
    |> Map.get("front_default")
  end
end
