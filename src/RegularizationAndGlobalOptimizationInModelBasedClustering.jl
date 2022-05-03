module RegularizationAndGlobalOptimizationInModelBasedClustering

using ArgParse
using Clustering
using CSV
using DataFrames
using DelimitedFiles
using UnsupervisedLearning
using TimerOutputs

using Dates
using Random

# constants

# initializations
function initialize()
    return nothing
end

include("benchmark.jl")
include("dataset.jl")
include("version.jl")

function version()
    return _VERSION
end

function run()
    Random.seed!(1)

    benchmark = Benchmark()

    push!(benchmark, UnsupervisedLearning.kmeans)
    push!(benchmark, UnsupervisedLearning.kmeans_ms)
    push!(benchmark, UnsupervisedLearning.kmeans_rs)
    push!(benchmark, UnsupervisedLearning.kmeans_hg)

    push!(benchmark, UnsupervisedLearning.gmm)
    push!(benchmark, UnsupervisedLearning.gmm_shrunk)
    push!(benchmark, UnsupervisedLearning.gmm_oas)
    push!(benchmark, UnsupervisedLearning.gmm_ledoitwolf)

    push!(benchmark, UnsupervisedLearning.gmm_ms)
    push!(benchmark, UnsupervisedLearning.gmm_ms_shrunk)
    push!(benchmark, UnsupervisedLearning.gmm_ms_oas)
    push!(benchmark, UnsupervisedLearning.gmm_ms_ledoitwolf)

    push!(benchmark, UnsupervisedLearning.gmm_rs)
    push!(benchmark, UnsupervisedLearning.gmm_rs_shrunk)
    push!(benchmark, UnsupervisedLearning.gmm_rs_oas)
    push!(benchmark, UnsupervisedLearning.gmm_rs_ledoitwolf)

    push!(benchmark, UnsupervisedLearning.gmm_hg)
    push!(benchmark, UnsupervisedLearning.gmm_hg_shrunk)
    push!(benchmark, UnsupervisedLearning.gmm_hg_oas)
    push!(benchmark, UnsupervisedLearning.gmm_hg_ledoitwolf)

    now = Dates.now()
    benchmark_name = "$(Dates.year(now))-$(Dates.month(now))-$(Dates.day(now))_$(Dates.hour(now))-$(Dates.minute(now))-$(Dates.second(now))"

    # precompile 
    run(benchmark, 100, 3, 2, -0.26, 1)
    clean!(benchmark)

    n = 100
    for k in [3] # 3,10,20
        for c in [0.01] # -0.26,-0.1,0.01,0.21
            for d in [2, 5, 10, 20, 30, 40] # 2,5,10,20,30,40
                for i in 1:20
                    run(benchmark, n, k, d, c, i)
                end

                save(benchmark, joinpath(".", "results", "$(benchmark_name).csv"))
            end
        end
    end
end

include("main.jl")

end # module
