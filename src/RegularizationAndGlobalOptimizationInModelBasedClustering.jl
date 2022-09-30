module RegularizationAndGlobalOptimizationInModelBasedClustering

using ArgParse
using Clustering
using Colors
using CSV
using DataFrames
using DelimitedFiles
using HypothesisTests
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
    "digits",
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
    "economics",
]

function initialize()
    return nothing
end

include("benchmark.jl")
include("dataset.jl")
include("postprocessing.jl")

function run(options::Dict{String, Any})
    Random.seed!(1)

    benchmark = Benchmark()

    for algorithm in options["algorithms"]
        if algorithm == 1
            push!(benchmark, UnsupervisedClustering.kmeans)
        elseif algorithm == 2
            push!(benchmark, UnsupervisedClustering.kmeans_ms)
        elseif algorithm == 3
            push!(benchmark, UnsupervisedClustering.kmeans_rs)
        elseif algorithm == 4
            push!(benchmark, UnsupervisedClustering.kmeans_hg)
        elseif algorithm == 5
            push!(benchmark, UnsupervisedClustering.gmm)
        elseif algorithm == 6
            push!(benchmark, UnsupervisedClustering.gmm_ms)
        elseif algorithm == 7
            push!(benchmark, UnsupervisedClustering.gmm_rs)
        elseif algorithm == 8
            push!(benchmark, UnsupervisedClustering.gmm_hg)
        elseif algorithm == 9
            push!(benchmark, UnsupervisedClustering.gmm_shrunk)
        elseif algorithm == 10
            push!(benchmark, UnsupervisedClustering.gmm_ms_shrunk)
        elseif algorithm == 11
            push!(benchmark, UnsupervisedClustering.gmm_rs_shrunk)
        elseif algorithm == 12
            push!(benchmark, UnsupervisedClustering.gmm_hg_shrunk)
        elseif algorithm == 13
            push!(benchmark, UnsupervisedClustering.gmm_oas)
        elseif algorithm == 14
            push!(benchmark, UnsupervisedClustering.gmm_ms_oas)
        elseif algorithm == 15
            push!(benchmark, UnsupervisedClustering.gmm_rs_oas)
        elseif algorithm == 16
            push!(benchmark, UnsupervisedClustering.gmm_hg_oas)
        elseif algorithm == 17
            push!(benchmark, UnsupervisedClustering.gmm_ledoitwolf)
        elseif algorithm == 18
            push!(benchmark, UnsupervisedClustering.gmm_ms_ledoitwolf)
        elseif algorithm == 19
            push!(benchmark, UnsupervisedClustering.gmm_rs_ledoitwolf)
        elseif algorithm == 20
            push!(benchmark, UnsupervisedClustering.gmm_hg_ledoitwolf)
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

    # precompile 
    run(benchmark, 3, 2, -0.26, 1)
    clean!(benchmark)

    for k in options["k"]
        for c in options["c"]
            for d in options["d"]
                for i in options["i"]
                    run(benchmark, k, d, c, i)
                end
                save(benchmark, joinpath(".", "results"), filename)
            end
        end
    end

    datasets_str = join(options["datasets"], ",")
    filename = "uci-[$datasets_str]-[$i_str]-$timestamp"

    if options["uci"]
        for dataset in options["datasets"]
            run(benchmark, uci_datasets[dataset], options["i"])
            save(benchmark, joinpath(".", "results"), filename)
        end

    #         "cervical_cancer",
    #         "economics",
    #         "liver-disorders",
            
    #         "glass",
    #         "heart",
            
    #         "heart-disease",
    #         "user_knowledge_modeling",
    #         "heart_failure_clinical",
            
    #         "breast-cancer-wisconsin",
    #         "breast",
    #         "congressional-voting",
            
    #         "pima-indians-diabetes",
    #         "scadi",
    #         "absenteeism_at_work",
    #         "banknote_authentication",
    #         "south_german_credit",
    #         # "circles_2d",
            
    #         "dow_jones_index",
         
    #         "parkinson_disease_spiral",
    #         "winequality_red",
    #         "sonar",
    #         # "simple_2d",
    #         "abalone",
    #         # "spheres_3d",
    #         "page-blocks"
    #         # "libras",
    #         # "winequality_white",

    #         # "shill_bidding",
    #         # 
    #         # "spam",
   
    #         # "egg",
    #         # 
    #         # 
    #         # 
    #         # 
    #         # "eeg-eye-state",
    #         # "htru2",
    #         # "anuran_calls",
    #         # "gas_turbine_emission",
    #         # "activity_recognition",
    #         # "skin",
    #         # "skin-segmentation",
    #         # "gesture_phase_segmentation",
    #         # "credit",
    #         # "urban-gb",
    #         # "gas-sensor",
    #         # "3d-road-network",
    #         # "sensorless-drive-diagnosis",
    #         # "isolet",
    #         # "har",
    #         # "gisette",
    
    #         # "urban-gb"
    # ]
    end
end

include("main.jl")

end
