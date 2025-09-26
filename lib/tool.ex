defmodule Elai.Tool do
  @moduledoc """
  Provides a struct and constructor for defining AI agent tools.
  """

  # Define a struct for a single tool parameter using TypedStruct
  defmodule Parameter do
    @moduledoc "Defines a single parameter for a tool's input schema."
    use TypedStruct

    @type parameter_type :: :string | :integer | :number | :boolean | :array | :object

    typedstruct enforce: true do
      plugin(TypedStructNimbleOptions)

      field :name, atom(), doc: "Parameter name"
      field :type, parameter_type(), doc: "Primitive type for the parameter"
      field :description, String.t(), doc: "Human readable description of the parameter"
      field :required?, boolean(), default: true, enforce: false, doc: "Indicates if parameter is required"
    end
  end

  @type parameter_options :: [
          type: Parameter.parameter_type(),
          description: String.t(),
          required?: boolean()
        ]

  @type tool_options :: [
          name: atom(),
          description: String.t(),
          parameters: [{atom(), parameter_options()}]
        ]

  @type api_format :: %{
          String.t() => String.t() | atom() | map()
        }

  use TypedStruct

  typedstruct enforce: true do
    plugin(TypedStructNimbleOptions)

    field :name, atom(), doc: "Name of the tool"
    field :description, String.t(), doc: "Description of what the tool does"
    field :parameters, [Parameter.t()], default: [], enforce: false, doc: "List of parameter definitions"
  end

  defimpl Jason.Encoder, for: Elai.Tool do
    def encode(%Elai.Tool{} = tool, opts) do
      tool
      |> Elai.Tool.to_api_format()
      |> Jason.Encoder.encode(opts)
    end
  end

  @doc """
  Creates a new Tool struct.

  ## Options

    * `:name` (atom, required) - The name of the tool.
    * `:description` (string, required) - A description of what the tool does.
    * `:parameters` (list, optional) - A list of parameter tuples.

  ## Example

      Tool.new(
        name: :get_weather,
        description: "Gets the current weather for a location",
        parameters: [
          {:location, [type: :string, description: "The city, e.g. Denver, CO"]},
          {:unit, [type: :string, description: "The temperature unit (celsius or fahrenheit)", required?: false]}
        ]
      )
  """
  @spec new(tool_options()) :: t()
  def new(opts) do
    params_data = Keyword.get(opts, :parameters, [])

    parameters =
      Enum.map(params_data, fn {name, p_opts} ->
        %Parameter{
          name: name,
          type: Keyword.fetch!(p_opts, :type),
            description: Keyword.fetch!(p_opts, :description),
          required?: Keyword.get(p_opts, :required?, true)
        }
      end)

    %__MODULE__{
      name: Keyword.fetch!(opts, :name),
      description: Keyword.fetch!(opts, :description),
      parameters: parameters
    }
  end

  @doc """
  Converts a Tool struct into the map format required by the Anthropic API.
  """
  @spec to_api_format(t()) :: api_format()
  def to_api_format(%__MODULE__{} = tool) do
    %{
      "name" => tool.name,
      "description" => tool.description,
      "input_schema" => build_input_schema(tool.parameters)
    }
  end

  # Private helper to generate the input_schema map
  @spec build_input_schema([Parameter.t()]) :: map()
  defp build_input_schema(parameters) do
    properties =
      Enum.reduce(parameters, %{}, fn param, acc ->
        param_schema = %{
          "type" => param.type,
          "description" => param.description
        }

        Map.put(acc, param.name, param_schema)
      end)

    required =
      parameters
      |> Enum.filter(& &1.required?)
      |> Enum.map(& &1.name)

    %{
      "type" => "object",
      "properties" => properties,
      "required" => required
    }
  end
end
