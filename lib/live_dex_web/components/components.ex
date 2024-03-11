defmodule LiveDexWeb.Components do
  @moduledoc false
  use Phoenix.Component

  def card(assigns) do
    ~H"""
    <div
      href="#"
      class="mx-auto w-full flex mt-10 flex-col max-w-9xl items-center bg-white border border-gray-200 rounded-lg shadow md:flex-row md:max-w-xl"
    >
      <img
        class="object-cover w-full rounded-t-lg h-96 md:h-auto md:w-48 md:rounded-none md:rounded-s-lg"
        src={@url}
        alt=""
      />
      <div class="flex flex-col justify-between p-4 leading-normal">
        <div class="flex flex-row justify-start items-center h-full">
          <div class="mt-2">
            <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900">
              <%= String.upcase(@name) %>
            </h5>
          </div>
          <div class="ml-4">
            <span class="bg-blue-100 text-blue-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded">
              #<%= @id %>
            </span>
          </div>
        </div>
        <!-- Pokemon Stats -->
        <ul id="stats" class="w-full mr-14 mb-5 mt-5">
          <li :for={{name, value} <- @stats} id={name} class="flex flex-row justify-between">
            <p class="font-semibold"><%= String.upcase(name) %>:</p>
            <p class="ml-4"><%= value %></p>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def button(assigns) do
    ~H"""
    <button
      phx-click={@click}
      type="button"
      class="py-2.5 px-5 me-2 mb-2 mr-10 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100"
    >
      <%= @placeholder %>
    </button>
    """
  end

  def toggle_button(assigns) do
    ~H"""
    <label class="inline-flex items-center cursor-pointer mt-4">
      <input type="checkbox" value="" class="sr-only peer" phx-click={@click} checked={@checked} />
      <div class="relative w-11 h-6 bg-gray-700 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600">
      </div>
      <div class="ms-3 text-sm font-medium text-black">
        <%= @placeholder %>
      </div>
    </label>
    """
  end
end
