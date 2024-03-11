# LiveDex

LiveDex is a web app where users can search and navigate through the various Pokémons available and check some of their stats with the resource of [PokeAPI](https://pokeapi.co/).


## Stack choice

For this project, Elixir was the chosen stack, given my focus on backend development, complemented by Phoenix LiveView, the natural fit for a web application with user interactivity.

Moreover, to streamline the implementation of the caching mechanism and leverage existing solutions, LiveDex utilizes the Elixir [Cachex](https://hexdocs.pm/cachex/getting-started.html) library, which harnesses the power of [ETS](https://hexdocs.pm/elixir/main/ets.html) for efficient data storage.


## Project overview

### Frontend

As said before, for the front end I chose the amazing Phoenix LiveView, since my application has some interactivity with the user.
I also organized some of the code with components, in order to improve readability and future work.

### Backend

For the backend, I organized my code in the `LiveDex.Pokemon` module, where all of the data fetching and caching mechanism is done.

The caching mechanism works in a way to enhance the overall smoothness of the application, since the data comes from an API and might suffer delays.
There are two ways that a Pokémon can be cached:
- By ID;
- By Name;

Every time a Pokémon is searched in the search bar, either by name or ID, it will be cached using one of these identifiers with a __TTL__ of 3600. Similarly, when navigating with the Prev and Next buttons, the Pokémon will be cached using its ID as the key.

Additionally, to enhance user experience, LiveDex pre-loads the next and previous Pokémon into the cache with each search, using a __TTL__ of 600. This optimization ensures that navigation using the `Prev` and `Next` buttons remains smooth and seamless.

## Future work

Since this project was made on a time schedule, there could be some things that could be improved in the future.

Primarily, the application's frontend aesthetic could benefit from further refinement, incorporating additional details about each Pokémon. Additionally, refining the organization of the frontend by introducing more modular components beyond those currently in use would enhance the overall developer experience.

Moreover, it's essential to consider optimizing the storage of Pokémon data by solely utilizing their names, instead of both their ID and name, in future iterations. While the current method suffices for the current scenario, where the data size for each key-value pair is minimal, it may not be ideal for handling larger datasets efficiently. By focusing solely on storing Pokémon by their names, we can ensure a more streamlined and efficient caching mechanism, particularly when dealing with larger volumes of data.

## Running the project

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

