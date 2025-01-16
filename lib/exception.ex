defmodule ExPdfPoppler.Error do
  @moduledoc """
  An exception that is raised when a ExPdfPoppler action fails
  """
  defexception [:reason, action: ""]

  @impl true
  def message(%{action: action, reason: reason}) do
    "could not do ExPdfPoppler action: #{action} reason: #{reason}"
  end
end
