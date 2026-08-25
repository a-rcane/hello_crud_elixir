defmodule HelloCrudElixir.Router do
  use Plug.Router

  plug(Plug.Static,
    at: "/",
    from: :hello_crud_elixir,
    only: ~w(index.html)
  )

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "priv/static/index.html")
  end

  get "/health" do
    conn
    |> json_resp(200, %{status: :ok})
  end

  get "/api/tasks" do
    tasks = HelloCrudElixir.Store.list_tasks()
    json_resp(conn, 200, tasks)
  end

  post "/api/tasks" do
    new_task = HelloCrudElixir.Store.create_task(conn.body_params)
    json_resp(conn, 201, new_task)
  end

  put "/api/tasks/:id" do
    case HelloCrudElixir.Store.update_task(id, conn.body_params) do
      {:ok, updated_task} ->
        json_resp(conn, 200, updated_task)

      {:error, :not_found} ->
        json_resp(conn, 404, %{error: "Task not found"})
    end
  end

  delete "/api/tasks/:id" do
    case HelloCrudElixir.Store.delete_task(id) do
      :ok ->
        json_resp(conn, 200, %{status: "success", message: "Task deleted successfully"})

      {:error, :not_found} ->
        json_resp(conn, 404, %{error: "Task not found"})
    end
  end

  match _ do
    json_resp(conn, 404, %{status: "error", message: "Route not found"})
  end

  defp json_resp(conn, status, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end
end
