defmodule Elai.Models.Claude do
  use TypedStruct

  @supported_models [
    # Claude 4 Models
    "claude-opus-4-1-20250805",
    "claude-opus-4-1",  # alias
    "claude-opus-4-20250514",
    "claude-opus-4-0",  # alias
    "claude-sonnet-4-20250514",
    "claude-sonnet-4-0",  # alias

    # Claude 3.7 Models
    "claude-3-7-sonnet-20250219",
    "claude-3-7-sonnet-latest",  # alias

    # Claude 3.5 Models
    "claude-3-5-haiku-20241022",
    "claude-3-5-haiku-latest",  # alias
    "claude-3-5-sonnet-latest",  # alias

    # Claude 3 Models
    "claude-3-opus-latest",  # alias
    "claude-3-haiku-20240307"
  ]

  typedstruct enforce: true do
    plugin TypedStructNimbleOptions

    field :model, String.t(), validation_type: {:custom, __MODULE__, :check_model_name, []}, enforce: true, doc: "The Claude model name."
  end

  def check_model_name(name) do
    case name in @supported_models do
      true -> {:ok, name}
      false -> {:error, "Unsupported model, must be one of #{inspect(@supported_models)}"}
    end
  end
end
