defmodule CapsensQonto.Slack do
  def request_access_token(verification_code) do
    case response = HTTPoison.get!(
    "https://slack.com/api/oauth.access",
    [],
    params: %{
      client_id: Application.get_env(:capsens_qonto, :slack_client_id),
      client_secret: Application.get_env(:capsens_qonto, :slack_client_secret),
      code: verification_code,
      redirect_uri: CapsensQontoWeb.Router.Helpers.slack_auth_url(CapsensQontoWeb.Endpoint, :new)
    }
  ) do
      %HTTPoison.Response{status_code: 200, body: body} ->
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

  def list_channels(access_token) do
    case response =
      HTTPoison.get!("https://slack.com/api/conversations.list", [], params: %{token: access_token, types: "public_channel,private_channel", exclude_archived: true}) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        case payload = Jason.decode!(body) do
          %{"ok" => true} ->
            {:ok, channels: Enum.map(payload["channels"], fn(chan) -> chan["name"] end)}
          %{"ok" => false, "error" => error} ->
            {:error, error}
          _ ->
            {:error, payload}
        end
      _ ->
        {:error, response}
    end
  end

  def send_message(message, channel, access_token) do
    HTTPoison.get!("https://slack.com/api/chat.postMessage", [], params: %{token: access_token, channel: channel, text: message})
  end
end
