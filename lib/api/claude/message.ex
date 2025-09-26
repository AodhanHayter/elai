defmodule Elai.Api.Claude.Messages do
  use TypedStruct

  @derive {Jason.Encoder, only: [:model, :max_tokens, :messages, :system, :tools]}
  typedstruct enforce: true do
    plugin(TypedStructNimbleOptions)

    field(:model, String.t())
    field(:max_tokens, pos_integer())
    field(:messages, list(map()))
    field(:system, String.t() | list(String.t()), default: [])
    field(:tools, [Elai.Tool.t()], default: [])
  end
end
