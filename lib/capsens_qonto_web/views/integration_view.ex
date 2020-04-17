defmodule CapsensQontoWeb.IntegrationView do
  use CapsensQontoWeb, :view

  def qonto_sample(integration) do
    result =
      CapsensQonto.Transactions.list(integration.qonto_identifier, integration.qonto_secret_key, integration.qonto_iban, 1)
      |> Map.fetch!("transactions")
      |> List.first

    case result do
      %{"amount" => _} ->
        render("sample.html", result: result)
      nil ->
        render("no_sample.html")
    end
  end

  def slack_channels(user) do
    case CapsensQonto.Slack.list_channels(user.slack_access_token) do
      {:ok, channels: channels} ->
        channels
      {:error, error} ->
        []
    end
  end
end
