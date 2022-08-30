module RegularizationAndGlobalOptimizationInModelBasedClustering

using ArgParse
using Clustering
using CSV
using DataFrames
using DelimitedFiles
using UnsupervisedClustering
using TimerOutputs

using Dates
using Random

function initialize()
    return nothing
end

include("benchmark.jl")
include("dataset.jl")

function run(options::Dict{String, Any})
    Random.seed!(1)

    benchmark = Benchmark()

    push!(benchmark, UnsupervisedClustering.kmeans)
    push!(benchmark, UnsupervisedClustering.kmeans_ms)
    push!(benchmark, UnsupervisedClustering.kmeans_rs)
    push!(benchmark, UnsupervisedClustering.kmeans_hg)

    push!(benchmark, UnsupervisedClustering.gmm)
    push!(benchmark, UnsupervisedClustering.gmm_shrunk)
    push!(benchmark, UnsupervisedClustering.gmm_oas)
    push!(benchmark, UnsupervisedClustering.gmm_ledoitwolf)

    push!(benchmark, UnsupervisedClustering.gmm_ms)
    push!(benchmark, UnsupervisedClustering.gmm_ms_shrunk)
    push!(benchmark, UnsupervisedClustering.gmm_ms_oas)
    push!(benchmark, UnsupervisedClustering.gmm_ms_ledoitwolf)

    push!(benchmark, UnsupervisedClustering.gmm_rs)
    push!(benchmark, UnsupervisedClustering.gmm_rs_shrunk)
    push!(benchmark, UnsupervisedClustering.gmm_rs_oas)
    push!(benchmark, UnsupervisedClustering.gmm_rs_ledoitwolf)

    push!(benchmark, UnsupervisedClustering.gmm_hg)
    push!(benchmark, UnsupervisedClustering.gmm_hg_shrunk)
    push!(benchmark, UnsupervisedClustering.gmm_hg_oas)
    push!(benchmark, UnsupervisedClustering.gmm_hg_ledoitwolf)

    now = Dates.now()
    benchmark_name = "$(Dates.year(now))-$(Dates.month(now))-$(Dates.day(now))_$(Dates.hour(now))-$(Dates.minute(now))-$(Dates.second(now))"

    # precompile 
    run(benchmark, 100, 3, 2, -0.26, 1)
    clean!(benchmark)

    n = 100
    for k in options["k"]
        for c in options["c"]
            for d in options["d"]
                for i in 1:20
                    run(benchmark, n, k, d, c, i)
                end

                if !isdir(joinpath(".", "results"))
                    mkdir(joinpath(".", "results"))
                end

                save(benchmark, joinpath(".", "results", "$(benchmark_name).csv"))
            end
        end
    end
end

include("main.jl")

end # module
