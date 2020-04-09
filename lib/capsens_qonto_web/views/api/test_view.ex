defmodule CapsensQontoWeb.Api.TestView do
  use CapsensQontoWeb, :view

  def render("index.json", _params) do
    %{
      data: %{
        coucou: "foo"
      }
    }
  end
end
