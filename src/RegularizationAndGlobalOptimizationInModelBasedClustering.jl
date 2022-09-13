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
    push!(benchmark, UnsupervisedClustering.gmm_ms)
    push!(benchmark, UnsupervisedClustering.gmm_rs)
    push!(benchmark, UnsupervisedClustering.gmm_hg)

    push!(benchmark, UnsupervisedClustering.gmm_shrunk)
    push!(benchmark, UnsupervisedClustering.gmm_ms_shrunk)
    push!(benchmark, UnsupervisedClustering.gmm_rs_shrunk)
    push!(benchmark, UnsupervisedClustering.gmm_hg_shrunk)

    push!(benchmark, UnsupervisedClustering.gmm_oas)
    push!(benchmark, UnsupervisedClustering.gmm_ms_oas)
    push!(benchmark, UnsupervisedClustering.gmm_rs_oas)
    push!(benchmark, UnsupervisedClustering.gmm_hg_oas)

    push!(benchmark, UnsupervisedClustering.gmm_ledoitwolf)
    push!(benchmark, UnsupervisedClustering.gmm_ms_ledoitwolf)
    push!(benchmark, UnsupervisedClustering.gmm_rs_ledoitwolf)
    push!(benchmark, UnsupervisedClustering.gmm_hg_ledoitwolf)

    now = Dates.now()
    year = Dates.year(now)
    month = Dates.month(now)
    day = Dates.day(now)
    hour = Dates.hour(now)
    minute = Dates.minute(now)
    timestamp = "$year-$month-$day-$hour-$minute"
    filename = "$timestamp-$(join(options["k"], ","))-$(join(options["c"], ","))-$(join(options["d"], ","))"

    # precompile 
    run(benchmark, 100, 3, 2, -0.26, 1)
    clean!(benchmark)

    n = 100
    for k in options["k"]
        for c in options["c"]
            for d in options["d"]
                for i in options["i"]
                    run(benchmark, n, k, d, c, i)
                end
                save(benchmark, joinpath(".", "results"), filename)
            end
        end
    end

    if options["uci"]
        datasets = [
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
        ]

        for dataset in datasets
            run(benchmark, dataset)
            save(benchmark, joinpath(".", "results"), "$timestamp-uci")
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
