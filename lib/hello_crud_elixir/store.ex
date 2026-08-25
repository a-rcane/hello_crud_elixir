defmodule HelloCrudElixir.Store do
  @moduledoc """
  In-memory state store for managing tasks using elixir's agent
  """
  use Agent

  # 1. Start the agent process with an map %{} as its initial state
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  # 2. READ: Get all tasks as a list
  def list_tasks do
    Agent.get(__MODULE__, fn state -> Map.values(state) end)
  end

  # 3. CREATE: Generate a unique ID, construct a task, and store it
  def create_task(attrs) do
    Agent.get_and_update(__MODULE__, fn state ->
      id = System.unique_integer([:positive]) |> Integer.to_string()

      new_task = %{
        id: id,
        title: Map.get(attrs, "title", "Untitled Task"),
        description: Map.get(attrs, "description", ""),
        priority: Map.get(attrs, "priority", "medium"),
        completed: false,
        created_at: DateTime.utc_now() |> DateTime.to_string()
      }

      # Return structure: {value_to_return, new_state}
      {new_task, Map.put(state, id, new_task)}
    end)
  end

  # 4. UPDATE: Modify an existing task by its ID
  def update_task(id, attrs) do
    Agent.get_and_update(__MODULE__, fn state ->
      case Map.get(state, id) do
        nil ->
          {{:error, :not_found}, state}

        task ->
          # Normalize string keys from incoming JSON to atom keys
          normalized_attrs = normalize_attrs(attrs)
          updated_task = Map.merge(task, normalized_attrs) |> Map.put(:id, id)

          {{:ok, updated_task}, Map.put(state, id, updated_task)}
      end
    end)
  end

  # 5. DELETE: Remove a task by ID
  def delete_task(id) do
    Agent.get_and_update(__MODULE__, fn state ->
      if Map.has_key?(state, id) do
        {:ok, Map.delete(state, id)}
      else
        {{:error, :not_found}, state}
      end
    end)
  end

  # helper function to convert JSON request string keys to map atom keys
  # allows safe mapping of incoming keys to our task struct
  defp normalize_attrs(attrs) do
    for {key, value} <- attrs, into: %{} do
      case key do
        "title" -> {:title, value}
        "description" -> {:description, value}
        "priority" -> {:priority, value}
        "completed" -> {:completed, value}
        # ignore or pass-through unknown fields
        _ -> {key, value}
      end
    end
  end
end
