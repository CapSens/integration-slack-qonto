defmodule CapsensQonto.Transactions do
  def list(identifier, secret_key, iban) do
    case HTTPoison.get(
          "https://thirdparty.qonto.eu/v2/transactions",
          ["Authorization": "#{identifier}:#{secret_key}"],
          params: %{
            iban: iban
          }
        ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body) |> Map.fetch!("transactions")
      _ ->
        []
    end
  end
end
