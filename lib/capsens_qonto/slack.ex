defmodule CapsensQonto.Slack do
  def request_access_token(verification_code) do
    case response = HTTPoison.get(
    "https://slack.com/api/oauth.access",
    [],
    params: %{
      client_id: Application.get_env(:capsens_qonto, :slack_client_id),
      client_secret: Application.get_env(:capsens_qonto, :slack_client_secret),
      code: verification_code,
      redirect_uri: CapsensQontoWeb.Router.Helpers.slack_auth_url(CapsensQontoWeb.Endpoint, :new)
    }
  ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case payload = Jason.decode!(body) do
          %{"ok" => true} ->
            {:ok, access_token: payload["access_token"], user_id: payload["user_id"]}
          %{"ok" => false, "error" => error} ->
            {:error, error}
          _ ->
            {:error, payload}
        end
      _ ->
        {:error, response}
    end
  end
end
