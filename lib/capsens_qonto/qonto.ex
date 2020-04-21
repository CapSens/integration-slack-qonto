defmodule CapsensQonto.Qonto do
  def list_transactions(identifier, secret_key, iban, per_page \\ 100, current_page \\ 1) do
    case HTTPoison.get!(
          "https://thirdparty.qonto.eu/v2/transactions",
          ["Authorization": "#{identifier}:#{secret_key}"],
          params: %{
            iban: iban,
            per_page: per_page,
            current_page: current_page
          }
        ) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        Jason.decode!(body)
      _ ->
        []
    end
  end

  def list_bank_accounts(identifier, secret_key) do
    case HTTPoison.get!("https://thirdparty.qonto.eu/v2/organizations/#{identifier}", ["Authorization": "#{identifier}:#{secret_key}"]) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        case payload = Jason.decode!(body) do
          %{"organization" => %{"bank_accounts" => bank_accounts}} ->
            bank_accounts
          _ ->
            []
        end
    end
  end

  def send_report do
    integrations = CapsensQonto.Integration.list |> CapsensQonto.Repo.preload(:user)

    Enum.map(integrations, fn(integration) ->
      last_transaction =
        list_transactions(integration.qonto_identifier, integration.qonto_secret_key, integration.qonto_iban, 1)
        |> Map.fetch!("transactions")
        |> Enum.filter(fn(tr) -> Enum.member?(integration.qonto_transaction_type, tr["side"]) end)
        |> List.first

      cond do
        integration.last_transaction_id == nil ->
          update_integration_last_transaction_id(integration, last_transaction)
          report_transaction(integration, last_transaction)
        last_transaction["transaction_id"] != integration.last_transaction_id ->
          report_new_transactions(integration)
          update_integration_last_transaction_id(integration, last_transaction)
        true ->
          "No new transactions, nothing to do"
      end
    end)
  end

  defp report_new_transactions(integration, current_page \\ 1) do
    transactions     = list_transactions(integration.qonto_identifier, integration.qonto_secret_key, integration.qonto_iban, 100, 1)
    new_transactions =
      Enum.take_while(transactions["transactions"], fn(tr) -> tr["transaction_id"] != integration.last_transaction_id end)
    |> Enum.filter(fn(tr) -> Enum.member?(integration.qonto_transaction_type, tr["side"]) end)

    Enum.each(new_transactions, fn(transaction) ->
      report_transaction(integration, transaction)
      :timer.sleep(500)
    end)

    if transactions["meta"]["next_page"] && Enum.count(new_transactions) == 100 do
      report_new_transactions(integration, current_page + 1)
    end
  end

  defp report_transaction(integration, transaction) do
    if transaction do
      amount    = Number.Delimit.number_to_delimited(transaction["amount"])
      direction = if transaction["side"] == "credit", do: "entrant", else: "sortant"
      message   = "Un virement #{direction} de #{amount} #{transaction["currency"]} a été effectué. Label : #{transaction["label"]}"

      CapsensQonto.Slack.send_message(message, integration.slack_channel, integration.user.slack_access_token)
    end
  end

  defp update_integration_last_transaction_id(integration, transaction) do
    changeset = integration |> Ecto.Changeset.cast(%{"last_transaction_id" => transaction["transaction_id"]}, [:last_transaction_id])
    CapsensQonto.Integration.update(changeset)
  end
end
