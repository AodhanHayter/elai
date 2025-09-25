alias Elai.Models

defmodule Claude do
  def generate_text(message) do
    Models.Prompt.new!(
      system: "You are a helpful assistant that adds robot noises to responses.",
      prompt: message
    )
    |> Models.Claude.with_prompt!(model: "claude-3-5-haiku-latest")
    |> Elai.generate_text()
  end
end
