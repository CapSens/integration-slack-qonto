defmodule CapsensQonto.Slack do
  import CapsensQontoWeb.Gettext

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
    {:ok, users: users}       = fetch_users(access_token)
    {:ok, channels: channels} = fetch_channels(access_token)

    channels = Enum.map(channels, fn(chan) ->
      if chan.user do
        %{id: chan.id, name: extract_user_name(users, chan.user)}
      else
        %{id: chan.id, name: chan.name}
      end
    end)

    {:ok, channels: channels}
  rescue
    _ ->
      {:error, gettext("unknown_error")}
  end

  def send_message(message, channel, access_token) do
    HTTPoison.get!("https://slack.com/api/chat.postMessage", [], params: %{token: access_token, channel: channel, text: message})
  end

  defp fetch_channels(access_token, cursor \\ nil, result \\ []) do
    case response = HTTPoison.get!(
    "https://slack.com/api/conversations.list",
    [],
    params: %{token: access_token, types: "public_channel,private_channel,im", exclude_archived: true, cursor: cursor}
  ) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        case payload = Jason.decode!(body) do
          %{"ok" => true, "response_metadata" => %{"next_cursor" => ""}} ->
            {:ok, channels: result ++ channels_name(payload["channels"])}
          %{"ok" => true, "response_metadata" => %{"next_cursor" => next_cursor}} ->
            fetch_channels(access_token, next_cursor, result ++ channels_name(payload["channels"]))
          %{"ok" => false, "error" => error} ->
            {:error, error}
          _ ->
            {:error, payload}
        end
      _ ->
        {:error, response}
    end
  end

  defp fetch_users(access_token) do
    case response = HTTPoison.get!("https://slack.com/api/users.list", [], params: %{token: access_token}) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        case payload = Jason.decode!(body) do
          %{"ok" => true} ->
            {:ok, users: Enum.map(payload["members"], fn(user) -> %{name: user["name"], id: user["id"]} end)}
          %{"ok" => false, "error" => error} ->
            {:error, error}
          _ ->
            {:error, payload}
        end
      _ ->
        {:error, response}
    end
  end

  defp channels_name(channels) do
    Enum.map(channels, fn(chan) -> %{id: chan["id"], name: chan["name"], user: chan["user"]} end)
  end

  defp extract_user_name(users, user_id) do
    case user = Enum.find(users, fn(u) -> u.id == user_id end) do
      nil ->
        "erreur"
      _ ->
        user.name
    end
  end
end
