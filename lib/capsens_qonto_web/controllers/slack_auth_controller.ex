defmodule CapsensQontoWeb.SlackAuthController do
  use CapsensQontoWeb, :controller

  plug :fetch_access_token

  def new(conn, params) do
    render(conn, "new.html")
  end

  defp fetch_access_token(conn, _) do
    case CapsensQonto.Slack.request_access_token(conn.params["code"]) do
      {:ok, access_token: access_token, user_id: user_id, hook_url: hook_url} ->
        assign(conn, :user_id, user_id)
        assign(conn, :access_token, access_token)
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: "/")
        |> halt()
    end
  end
end
