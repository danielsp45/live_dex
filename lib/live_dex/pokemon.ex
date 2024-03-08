defmodule LiveDex.Pokemon do
  @api_url Application.compile_env(:live_dex, :api_url)

  defstruct [:name, :id, :stats, :sprite]

  @spec get_pokemon(String.t()) :: %LiveDex.Pokemon{} | {:error, term()}
  def get_pokemon(param) do
    param = String.downcase(param)
    url = @api_url <> "pokemon/" <> param

    with {:ok, response} <- HTTPoison.get(url),
         {:ok, result} <- extract_data(response) do
      {:ok, result}
    else
      {:error, reason} -> {:error, reason}
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
