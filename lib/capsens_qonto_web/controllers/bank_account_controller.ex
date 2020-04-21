defmodule CapsensQontoWeb.BankAccountController do
  use CapsensQontoWeb, :controller

  def index(conn, params) do
    bank_accounts = CapsensQonto.Qonto.list_bank_accounts(params["identifier"], params["secret_key"])

    render(conn, "index.json", bank_accounts: bank_accounts)
  end
end
