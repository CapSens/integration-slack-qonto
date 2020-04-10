defmodule CapsensQonto.Transactions do
  def fetch_transactions do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(
      "https://thirdparty.qonto.eu/v2/transactions",
      ["Authorization": Application.get_env(:capsens_qonto, :config)[:auth]],
      params: %{
        "iban" => Application.get_env(:capsens_qonto, :config)[:iban],
        "slug" => Application.get_env(:capsens_qonto, :config)[:bank_account]
      }
    )

    Jason.decode!(body) |> Map.fetch!("transactions")
  end
end
