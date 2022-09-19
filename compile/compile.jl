import Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

import PackageCompiler

PackageCompiler.create_app(
    dirname(@__DIR__),
    joinpath(@__DIR__, "build");
    executables = ["RegularizationAndGlobalOptimizationInModelBasedClustering" => "julia_main"],
    filter_stdlibs = true,
    incremental = false,
    include_lazy_artifacts = true,
    force = true,
    include_transitive_dependencies = false
)