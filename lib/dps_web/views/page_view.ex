defmodule DpsWeb.PageView do
  use DpsWeb, :view

  def poem_id_to_url(id) do
    "/poems/" <> Integer.to_string(id)
  end
end
