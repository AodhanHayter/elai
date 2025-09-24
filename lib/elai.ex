defmodule Elai do
  @moduledoc """
  Documentation for `Elai`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elai.hello()
      :world

  """
  alias Elai.Models
  alias Elai.Api

  require Logger

  def generate_text(model_struct, content) do
    Logger.debug("Generating text...")

    case model_struct do
      %Models.Claude{} ->
        Api.Claude.send_message(content, model_struct)
      _ -> Logger.warning("Unknown model")
    end

  end

  def stream_text() do
    Logger.info("Streaming text...")
  end
end
