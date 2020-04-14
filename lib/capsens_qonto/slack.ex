defmodule CapsensQonto.Slack do
  def request_access_token(verification_code) do
    case response = HTTPoison.get(
          "https://slack.com/api/oauth.v2.access",
          [],
          params: %{
            client_id: Application.get_env(:slack_client_id),
            client_secret: Application.get_env(:slack_client_secret),
            code: verification_code,
            redirect_uri: "http://localhost:4000/slack"
          }
        ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case payload = Jason.decode!(body) do
          %{"ok" => true} ->
            {:ok, payload["access_token"]}
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
