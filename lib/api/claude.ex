defmodule Elai.Api.Claude do
  @moduledoc """
  API interface to Claude
  """
  alias Elai.Api.Claude.Messages
  alias Elai.Models
  alias Elai.Prompt
  require Logger

  def send_message(prompt = %Prompt{}, model = %Models.Claude{}) do
    Logger.debug("Claude: sending message")

    {:ok, messages} =
      Messages.new(
        model: model.model,
        max_tokens: 1024,
        system: prompt.system,
        tools: prompt.tools,
        messages: construct_messages(prompt)
      )

    post("/messages", model, messages)
  end

  defp post(url_fragment, model, data) do
    req =
      Req.new(
        url: "#{model.base_url}/#{url_fragment}",
        method: :post,
        headers: build_headers(model),
        json: data
      )
      |> Req.Request.append_request_steps(
        debug_body: fn request ->
          IO.puts(request.body)
          request
        end
      )

    Req.post(req)
  end

  defp build_headers(model) do
    [
      {"accept", "application/json"},
      {"anthropic-version", "2023-06-01"},
      {"content-type", "application/json"},
      {"x-api-key", model.api_key}
    ]
  end

  defp construct_messages(prompt = %Prompt{}) do
    [%{role: "user", content: prompt.prompt}]
  end
end
