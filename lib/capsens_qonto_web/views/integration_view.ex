defmodule CapsensQontoWeb.IntegrationView do
  use CapsensQontoWeb, :view

  def qonto_sample(integration) do
    result =
      CapsensQonto.Transactions.list(integration.qonto_identifier, integration.qonto_secret_key, integration.qonto_iban)
      |> List.first

    case result do
      %{"amount" => _} ->
        render("sample.html", result: result)
      nil ->
        render("no_sample.html")
    end
  end

  def slack_channels(user) do
    {:ok, channels: channels} = CapsensQonto.Slack.list_channels(user.slack_access_token)
    channels
  end
end
