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
end
