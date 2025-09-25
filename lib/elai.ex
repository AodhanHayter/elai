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
  alias Elai.Prompt

  require Logger

  def generate_text(%{prompt: prompt} = model) do
    Logger.debug("Generating text...")

    prompt = Prompt.new!(prompt: prompt.prompt, system: prompt.system)

    case model do
      %Models.Claude{} ->
        Api.Claude.send_message(prompt, model)

      _ ->
        Logger.warning("Unknown model")
    end
  end

  def stream_text() do
    Logger.info("Streaming text...")
  end
end
