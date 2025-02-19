defmodule ExPdfPoppler.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_pdf_poppler,
      version: "0.3.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A Elixir library for working with PDFs using poppler rendering library",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: :ex_pdf_poppler,
      maintainers: ["Matthias Van Woensel"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/matthiaz/ex_pdf_poppler"},
      files: ~w(lib mix.exs README.md LICENSE.md)
    ]
  end
end
