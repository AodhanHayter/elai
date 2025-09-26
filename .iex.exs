alias Elai.Models
alias Elai.Prompt

defmodule Claude do
  def generate_text(message) do
    weather_tool =
      Elai.Tool.new(
        name: :get_weather,
        description: "Gets the current weather for a location",
        parameters: [
          {:location, [type: :string, description: "The city, e.g. Denver, CO"]},
          {:unit,
           [
             type: :string,
             description: "The temperature unit (celsius or fahrenheit)",
             required?: false
           ]}
        ]
      )

    Prompt.new!(
      tools: [weather_tool],
      # system: "You are a helpful assistant that adds robot noises to responses.",
      prompt: message
    )
    |> Models.Claude.with_prompt!(model: "claude-3-5-haiku-latest")
    |> Elai.generate_text()
  end
end
