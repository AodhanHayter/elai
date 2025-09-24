defmodule Elai.Api.Claude do
  @moduledoc """
  API interface to Claude
  """
  alias Elai.Api.Claude.Messages
  require Logger

  def send_message(content, %{model: model}) do
    Logger.debug("Claude: sending message")
    Messages.new(
      model: model,
      max_tokens: 1024,
      messages: [%{role: "user", content: content}]
    )
  end
end
