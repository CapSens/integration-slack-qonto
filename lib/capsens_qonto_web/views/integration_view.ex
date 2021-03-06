defmodule CapsensQontoWeb.IntegrationView do
  use CapsensQontoWeb, :view

  def qonto_sample(integration) do
    result =
      CapsensQonto.Qonto.list_transactions(integration.qonto_identifier, integration.qonto_secret_key, integration.qonto_iban, 1)
      |> Map.fetch!("transactions")
      |> List.first

    case result do
      %{"amount" => _} ->
        render("sample.html", result: result)
      nil ->
        render("no_sample.html")
    end
  rescue
    _ -> render("no_sample.html")
  end

  def slack_channels(user) do
    case CapsensQonto.Slack.list_channels(user.slack_access_token) do
      {:ok, channels: channels} ->
        Enum.map(channels, fn(chan) -> {chan.name, chan.id} end)
      {:error, error} ->
        []
    end
  end
end
