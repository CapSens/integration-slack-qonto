defmodule CapsensQontoWeb.BankAccountView do
  use CapsensQontoWeb, :view

  def render("index.json", %{bank_accounts: bank_accounts}) do
    Enum.map(bank_accounts, fn(bank_account) ->
      bank_account["iban"]
    end)
  end
end
