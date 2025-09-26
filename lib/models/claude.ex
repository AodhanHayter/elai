defmodule Elai.Models.Claude do
  use TypedStruct
  alias Elai.Prompt

  @base_url "https://api.anthropic.com/v1"

  @supported_models [
    # Claude 4 Models
    "claude-opus-4-1-20250805",
    # alias
    "claude-opus-4-1",
    "claude-opus-4-20250514",
    # alias
    "claude-opus-4-0",
    "claude-sonnet-4-20250514",
    # alias
    "claude-sonnet-4-0",

    # Claude 3.7 Models
    "claude-3-7-sonnet-20250219",
    # alias
    "claude-3-7-sonnet-latest",

    # Claude 3.5 Models
    "claude-3-5-haiku-20241022",
    # alias
    "claude-3-5-haiku-latest",
    # alias
    "claude-3-5-sonnet-latest",

    # Claude 3 Models
    # alias
    "claude-3-opus-latest",
    "claude-3-haiku-20240307"
  ]

  typedstruct enforce: true do
    plugin(TypedStructNimbleOptions)

    field(:api_key, String.t(),
      default: nil,
      validation_type: {:custom, __MODULE__, :check_api_key, []},
      enforce: true,
      doc: "API key for using Claude API."
    )

    field(:base_url, String.t(),
      default: @base_url,
      enforce: true,
      doc: "Base url for Claude API calls"
    )

    field(:model, String.t(),
      validation_type: {:custom, __MODULE__, :check_model_name, []},
      enforce: true,
      doc: "The Claude model name."
    )

    field(:prompt, Prompt.t(),
      validation_type: {:nested_struct, Prompt, :new},
      enforce: true,
      doc: "The prompt to send to Claude."
    )
  end

  def with_prompt!(prompt, opts) when is_map(prompt) do
    opts
    |> Keyword.put(:prompt, prompt)
    |> IO.inspect(label: "with_prompt! opts")
    |> new!()
  end

  def check_api_key(key) when is_binary(key) do
    {:ok, key}
  end

  def check_api_key(nil) do
    # Attempt to load the API key from the environment when none is provided explicitly.
    # This allows callers to omit :api_key and rely on ANTHROPIC_API_KEY being set.
    case System.get_env("ANTHROPIC_API_KEY") do
      key when is_binary(key) and byte_size(key) > 0 ->
        {:ok, key}

      _ ->
        {:error,
         "Missing API key. Provide :api_key option or set ANTHROPIC_API_KEY environment variable."}
    end
  end

  def check_model_name(name) do
    case name in @supported_models do
      true -> {:ok, name}
      false -> {:error, "Unsupported model, must be one of #{inspect(@supported_models)}"}
    end
  end
end
