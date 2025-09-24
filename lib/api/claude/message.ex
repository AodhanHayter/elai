defmodule Elai.Api.Claude.Messages do
  use TypedStruct

  typedstruct enforce: true do
    plugin TypedStructNimbleOptions

    field :model, String.t()
    field :max_tokens, pos_integer()
    field :messages, list(map())
  end
end
