defmodule Elai.Prompt do
  use TypedStruct
  alias Elais.Tool

  typedstruct enforce: true do
    plugin(TypedStructNimbleOptions)

    field(:prompt, String.t(), enforce: true, doc: "User prompt to send to the LLM")

    field(:system, String.t() | list(String.t()),
      default: [],
      enforce: true,
      doc: "System prompt to send to the LLM"
    )

    field(:tools, list(Tool.t()),
      default: [],
      enforce: true,
      doc: "List of tools for LLM to utilize"
    )
  end
end
