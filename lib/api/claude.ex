defmodule Elai.Api.Claude do
  @moduledoc """
  API interface to Claude
  """
  alias Elai.Api.Claude.Messages
  alias Elai.Models
  require Logger

  def send_message(prompt = %Models.Prompt{}, model = %Models.Claude{}) do
    Logger.debug("Claude: sending message")

    {:ok, messages} =
      Messages.new(
        model: model.model,
        max_tokens: 1024,
        system: prompt.system,
        messages: construct_messages(prompt)
      )

    post(model, "/messages", messages)
  end

  defp post(model, url_fragment, data) do
    Req.post(
      url: "#{model.base_url}/#{url_fragment}",
      method: :post,
      headers: build_headers(model),
      json: data
    )
  end

  defp build_headers(model) do
    [
      {"accept", "application/json"},
      {"anthropic-version", "2023-06-01"},
      {"content-type", "application/json"},
      {"x-api-key", model.api_key}
    ]
  end

  defp construct_messages(prompt = %Models.Prompt{}) do
    [%{role: "user", content: prompt.prompt}]
  end
end
