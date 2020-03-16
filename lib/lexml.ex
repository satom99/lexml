defmodule Lexml do
    @moduledoc false

    import Record

    for {name, attributes} <- extract_all(from_lib: "xmerl/include/xmerl.hrl") do
        defrecordp(name, attributes)
    end

    def parse(content) do
        content
        |> :binary.bin_to_list
        |> :xmerl_scan.string
        |> Kernel.elem(0)
        |> List.wrap
        |> process
    end

    defp process(records) when is_list(records) do
        records
        |> Stream.map(&process/1)
        |> Stream.filter(& &1)
        |> Enum.reduce(%{}, &transform/2)
    end
    defp process(element) when is_record(element, :xmlElement) do
        name = xmlElement(element, :name)
        content = xmlElement(element, :content)
        attributes = xmlElement(element, :attributes)
        value = process(content ++ attributes)
        {name, value}
    end
    defp process(attribute) when is_record(attribute, :xmlAttribute) do
        name = xmlAttribute(attribute, :name)
        value = xmlAttribute(attribute, :value)
        {name, value}
    end
    defp process(_record) do
        nil
    end

    defp transform(attribute, accumulator) do
        attribute
        |> List.wrap
        |> Map.new
        |> Map.merge(accumulator, &transform/3)
    end
    defp transform(_key, %{} = first, second) when is_list(second) do
        [first | second]
    end
    defp transform(_key, %{} = first, %{} = second) do
        [first, second]
    end
    defp transform(_key, first, _second) do
        first
    end
end