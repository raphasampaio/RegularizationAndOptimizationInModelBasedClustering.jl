module RegularizationAndGlobalOptimizationInModelBasedClustering

using ArgParse
using Clustering
using Colors
using CSV
using DataFrames
using DelimitedFiles
using HypothesisTests
using LinearAlgebra
using RegularizedCovarianceMatrices
using Printf
using UnsupervisedClustering
using TimerOutputs

using Dates
using Printf
using Random
using Statistics

const translation = Dict(
    "kmeans" => "k-means",
    "kmeans_ms" => "k-means MS",
    "kmeans_rs" => "k-means RS",
    "kmeans_hg" => "k-means HG",
    "gmm" => "GMM",
    "gmm_ms" => "GMM MS",
    "gmm_rs" => "GMM RS",
    "gmm_hg" => "GMM HG",
    "gmm_shrunk" => "GMM Shrunk",
    "gmm_ms_shrunk" => "GMM MS Shrunk",
    "gmm_rs_shrunk" => "GMM RS Shrunk",
    "gmm_hg_shrunk" => "GMM HG Shrunk",
    "gmm_oas" => "GMM OAS",
    "gmm_ms_oas" => "GMM MS OAS",
    "gmm_rs_oas" => "GMM RS OAS",
    "gmm_hg_oas" => "GMM HG OAS",
    "gmm_ledoitwolf" => "GMM Ledoitwolf",
    "gmm_ms_ledoitwolf" => "GMM MS Ledoitwolf",
    "gmm_rs_ledoitwolf" => "GMM RS Ledoitwolf",
    "gmm_hg_ledoitwolf" => "GMM HG Ledoitwolf",
)

const uci_datasets = [
    "facebook_live_sellers",
    "handwritten_digits",
    "hcv",
    "human_activity_recognition",
    "image_segmentation",
    "ionosphere",
    "iris",
    "letter_recognition",
    "magic",
    "mice_protein",
    "pendigits",
    "seeds",
    "spect",
    "shuttle",
    "wholesale",
    "wines",
    "yeast",
    "waveform",
    "scadi",
    "glass",
    "mnist",
    "fashion_mnist",
]

const uci_translation = Dict(
    "facebook_live_sellers" => "Facebook Live Sellers \\citep{dehouche2018facebook}",
    "handwritten_digits" => "Handwritten Digits",
    "hcv" => "HCV",
    "human_activity_recognition" => "Human Activity Recognition \\citep{anguita2013public}",
    "image_segmentation" => "Image Segmentation",
    "ionosphere" => "Ionosphere",
    "iris" => "Iris",
    "letter_recognition" => "Letter Recognition",
    "magic" => "MAGIC Gamma Telescope",
    "mice_protein" => "Mice Protein Expression \\citep{higuera2015self}",
    "pendigits" => "Pen-Based Recognition",
    "seeds" => "Seeds",
    "spect" => "SPECT Heart",
    "shuttle" => "Statlog (Shuttle)",
    "wholesale" => "Wholesale Customers",
    "wines" => "Wines",
    "yeast" => "Yeast",
    "waveform" => "Waveform",
    "scadi" => "Scadi",
    "glass" => "Glass",
    "mnist" => "MNIST",
    "fashion_mnist" => "Fashion MNIST",
)

function initialize()
    return nothing
end

include("dataset.jl")
include("evaluation.jl")
include("benchmark.jl")
include("postprocessing.jl")

function run(options::Dict{String, Any})
    Sys.cpu_summary()

    benchmark = Benchmark()

    for algorithm in options["algorithms"]
        if algorithm == 1
            push!(benchmark, :kmeans)
        elseif algorithm == 2
            push!(benchmark, :kmeans_ms)
        elseif algorithm == 3
            push!(benchmark, :kmeans_rs)
        elseif algorithm == 4
            push!(benchmark, :kmeans_hg)
        elseif algorithm == 5
            push!(benchmark, :gmm)
        elseif algorithm == 6
            push!(benchmark, :gmm_ms)
        elseif algorithm == 7
            push!(benchmark, :gmm_rs)
        elseif algorithm == 8
            push!(benchmark, :gmm_hg)
        elseif algorithm == 9
            push!(benchmark, :gmm_shrunk)
        elseif algorithm == 10
            push!(benchmark, :gmm_ms_shrunk)
        elseif algorithm == 11
            push!(benchmark, :gmm_rs_shrunk)
        elseif algorithm == 12
            push!(benchmark, :gmm_hg_shrunk)
        elseif algorithm == 13
            push!(benchmark, :gmm_oas)
        elseif algorithm == 14
            push!(benchmark, :gmm_ms_oas)
        elseif algorithm == 15
            push!(benchmark, :gmm_rs_oas)
        elseif algorithm == 16
            push!(benchmark, :gmm_hg_oas)
        elseif algorithm == 17
            push!(benchmark, :gmm_ledoitwolf)
        elseif algorithm == 18
            push!(benchmark, :gmm_ms_ledoitwolf)
        elseif algorithm == 19
            push!(benchmark, :gmm_rs_ledoitwolf)
        elseif algorithm == 20
            push!(benchmark, :gmm_hg_ledoitwolf)
        end
    end

    now = Dates.now()
    year = Dates.year(now)
    month = Dates.month(now)
    day = Dates.day(now)
    hour = Dates.hour(now)
    minute = Dates.minute(now)
    second = Dates.second(now)
    timestamp = "$year-$month-$day-$hour-$minute-$second"

    k_str = join(options["k"], ",")
    c_str = join(options["c"], ",")
    d_str = join(options["d"], ",")
    i_str = join(options["i"], ",")

    filename = "[$k_str]-[$c_str]-[$d_str]-[$i_str]-$timestamp"

    tolerance = options["tolerance"]
    maxiterations = options["maxiterations"]

    # precompile
    run(benchmark, 3, 2, -0.26, 1, tolerance, maxiterations)
    clean!(benchmark)

    for k in options["k"]
        for c in options["c"]
            for d in options["d"]
                for i in options["i"]
                    run(benchmark, k, d, c, i, tolerance, maxiterations)
                end
                save(benchmark, "..", filename)
            end
        end
    end

    datasets_str = join(options["datasets"], ",")
    filename = "uci-[$datasets_str]-[$i_str]-$timestamp"

    if options["uci"]
        for dataset in options["datasets"]
            run(benchmark, uci_datasets[dataset], options["i"], tolerance, maxiterations)
            save(benchmark, "..", filename)
        end
    end
end

include("main.jl")

end
