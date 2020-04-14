defmodule CapsensQontoWeb.SlackController do
  use CapsensQontoWeb, :controller

  def new(conn, params) do
    case CapsensQonto.Slack.request_access_token(params["code"]) do
      {:ok, access_token: access_token, user_id: user_id, hook_url: hook_url} ->
        case CapsensQonto.App.create(%{slack_access_token: access_token, slack_user_id: user_id, slack_hook_url: hook_url}) do
          {:ok, app} ->
            conn
            |> put_flash(:info, gettext("slack_success"))
            |> redirect(to: Routes.app_path(conn, :edit, app.id))
          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:error, "une erreur est survenue")
            |> redirect(to: Routes.app_path(conn, :new))
        end
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: Routes.app_path(conn, :new))
    end
  end
end
