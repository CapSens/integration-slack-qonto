defmodule CapsensQontoWeb.SlackAuthController do
  use CapsensQontoWeb, :controller

  plug :fetch_access_token
  plug :find_or_create_user
  plug :authenticate_user

  def new(conn, params) do
    conn |> redirect(to: Routes.integration_path(conn, :index))
  end

  defp fetch_access_token(conn, _) do
    case CapsensQonto.Slack.request_access_token(conn.params["code"]) do
      {:ok, access_token: slack_access_token, user_id: slack_user_id, team_name: slack_team_name} ->
        conn = assign(conn, :slack_user_id, slack_user_id)
        conn = assign(conn, :slack_access_token, slack_access_token)
        conn = assign(conn, :slack_team_name, slack_team_name)
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt()
    end
  end

  defp find_or_create_user(conn, _) do
    case CapsensQonto.User.find_by(slack_user_id: conn.assigns[:slack_user_id]) do
      nil ->
        case CapsensQonto.User.create(
              %{
                slack_user_id: conn.assigns[:slack_user_id],
                slack_access_token: conn.assigns[:slack_access_token],
                slack_team_name: conn.assigns[:slack_team_name]
              }
            ) do
          {:ok, user} ->
            assign(conn, :user, user)
          {:error, %Ecto.Changeset{}} ->
            conn
            |> put_flash(:error, gettext("unknown_error"))
            |> redirect(to: "/")
            |> halt()
        end
      user ->
        CapsensQonto.User.update(
          CapsensQonto.User.changeset(
            user,
            %{slack_access_token: conn.assigns[:slack_access_token], slack_team_name: conn.assigns[:slack_team_name]}
          )
        )
        assign(conn, :user, user)
    end
  end

  defp authenticate_user(conn, _) do
    conn
    |> put_flash(:info, gettext("signed_in"))
    |> CapsensQontoWeb.Guardian.Plug.sign_in(conn.assigns[:user])
  end
end
