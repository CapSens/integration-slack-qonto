defmodule CapsensQonto.Transactions do
  def list(identifier, secret_key, iban, bank_account) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(
      "https://thirdparty.qonto.eu/v2/transactions",
      ["Authorization": "#{identifier}:#{secret_key}"],
      params: %{
        iban: iban,
        slug: bank_account
      }
    )

    Jason.decode!(body) |> Map.fetch!("transactions")
  end
end
