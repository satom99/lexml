defmodule Lexml.MixProject do
    use Mix.Project

    def project do
        [
            app: :lexml,
            version: "0.0.1",
            build_embedded: Mix.env() == :prod,
            deps: deps()
        ]
    end

    defp deps do
        [
            {:ex_doc, "~> 0.21.3", only: :dev}
        ]
    end
end