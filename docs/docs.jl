import Pkg
Pkg.activate(dirname(@__DIR__))
Pkg.instantiate()
using RegularizationAndGlobalOptimizationInModelBasedClustering

Pkg.activate(@__DIR__)
Pkg.instantiate()
using Documenter

makedocs(;
    modules = [RegularizationAndGlobalOptimizationInModelBasedClustering],
    doctest = true,
    clean = true,
    format = Documenter.HTML(mathengine = Documenter.MathJax2()),
    sitename = "RegularizationAndGlobalOptimizationInModelBasedClustering",
    pages = ["Home" => "index.md"],
)
