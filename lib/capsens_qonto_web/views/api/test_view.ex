defmodule CapsensQontoWeb.Api.TestView do
  use CapsensQontoWeb, :view

  def render("index.json", %{}) do
    %{
      data: %{
        coucou: "foo"
      }
    }
  end
end
