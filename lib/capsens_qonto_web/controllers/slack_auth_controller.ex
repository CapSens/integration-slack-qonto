defmodule CapsensQontoWeb.SlackAuthController do
  use CapsensQontoWeb, :controller

  plug :fetch_access_token
  plug :find_or_create_user
  plug :authenticate_user

  def new(conn, params) do
    conn |> redirect(to: "/")
  end

  defp fetch_access_token(conn, _) do
    case CapsensQonto.Slack.request_access_token(conn.params["code"]) do
      {:ok, access_token: slack_access_token, user_id: slack_user_id} ->
        conn = assign(conn, :slack_user_id, slack_user_id)
        conn = assign(conn, :slack_access_token, slack_access_token)
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: "/")
        |> halt()
    end
  end

  defp find_or_create_user(conn, _) do
    case CapsensQonto.User.find_by(slack_user_id: conn.assigns[:slack_user_id]) do
      nil ->
        case CapsensQonto.User.create(%{slack_user_id: conn.assigns[:slack_user_id], slack_access_token: conn.assigns[:slack_access_token]}) do
          {:ok, user} ->
            assign(conn, :user, user)
          {:error, %Ecto.Changeset{}} ->
            conn
            |> put_flash(:error, gettext("unknown_error"))
            |> redirect(to: "/")
            |> halt()
        end
      user ->
        assign(conn, :user, user)
    end
  end

  defp authenticate_user(conn, _) do
    CapsensQontoWeb.Guardian.Plug.sign_in(conn, conn.assigns[:user])
  end
end
