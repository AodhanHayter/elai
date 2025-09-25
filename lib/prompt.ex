defmodule Elai.Prompt do
  use TypedStruct

  typedstruct enforce: true do
    plugin(TypedStructNimbleOptions)

    field(:prompt, String.t(), enforce: true, doc: "User prompt to send to the LLM")
    field(:system, String.t(), doc: "System prompt to send to the LLM")
  end
end
