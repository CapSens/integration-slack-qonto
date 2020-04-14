defmodule CapsensQontoWeb.SlackController do
  use CapsensQontoWeb, :controller

  def new(conn, params) do
    case CapsensQonto.Slack.request_access_token(params["code"]) do
      {:ok, access_token} ->
        conn
        |> put_flash(:info, gettext("slack_success"))
        |> redirect(to: Routes.app_path(conn, :new, access_token: access_token))
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: Routes.app_path(conn, :new))
    end
  end
end
