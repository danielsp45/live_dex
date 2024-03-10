defmodule LiveDex.PokemonTest do
  use ExUnit.Case, async: true
  alias LiveDex.Pokemon

  test "fetching a valid Pokemon" do
    {:ok, pokemon} = Pokemon.get_pokemon("pikachu", false)
    assert pokemon.name == "pikachu"
    assert length(pokemon.stats) == 6
    assert pokemon.sprite != nil
  end

  test "fetching an invalid Pokemon" do
    {:error, error} = Pokemon.get_pokemon("invalid_pokemon", true)

    assert error == :load_error
  end

  test "fetching a valid Pokemon with cache" do
    first_start = :os.system_time(:millisecond)
    {:ok, _} = Pokemon.get_pokemon("pikachu", true)
    first_end = :os.system_time(:millisecond)

    second_start = :os.system_time(:millisecond)
    {:ok, _} = Pokemon.get_pokemon("pikachu", true)
    second_end = :os.system_time(:millisecond)

    assert first_end - first_start > second_end - second_start
  end
end
