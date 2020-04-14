defmodule CapsensQontoWeb.AppView do
  use CapsensQontoWeb, :view

  def qonto_sample(app) do
    result =
      CapsensQonto.Transactions.list(app.qonto_identifier, app.qonto_secret_key, app.qonto_iban)
      |> List.first

    case result do
      %{"amount" => _} ->
        render("sample.html", result: result)
      nil ->
        render("no_sample.html")
    end
  end
end
