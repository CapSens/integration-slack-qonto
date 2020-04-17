defmodule CapsensQontoWeb.Guardian do
  use Guardian, otp_app: :capsens_qonto

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)

    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id       = claims["sub"]
    resource = CapsensQonto.User.get(id)

    case resource do
      nil ->
        {:error, :not_authed}
      _ ->
        {:ok, resource}
    end
  end
end
