defmodule CapsensQonto.Transactions do
  def list(identifier, secret_key, iban) do
    case HTTPoison.get!(
          "https://thirdparty.qonto.eu/v2/transactions",
          ["Authorization": "#{identifier}:#{secret_key}"],
          params: %{
            iban: iban
          }
        ) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        Jason.decode!(body) |> Map.fetch!("transactions")
      _ ->
        []
    end
  end

  def send_report do
    integration = CapsensQonto.Integration.list |> CapsensQonto.Repo.preload(:user) |> List.first
    CapsensQonto.Slack.send_message("coucou", integration.slack_channel, integration.user.slack_access_token)
  end
end
