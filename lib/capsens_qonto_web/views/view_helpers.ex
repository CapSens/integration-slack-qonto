defmodule CapsensQontoWeb.ViewHelpers do
  def current_user do
    CapsensQontoWeb.Guardian.Plug.current_resource(@conn)
  end
end
