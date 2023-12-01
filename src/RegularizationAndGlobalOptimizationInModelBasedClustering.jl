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
using StatsBase
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
    # "seeds",
    # "glass",
    # "446-scadi",
    # "hcv",
    # "yeast",
    # "image_segmentation",
    # "waveform",
    # "pendigits",
    # "letter_recognition",
    # "handwritten_digits",
    # "mice_protein",
    # "magic",
    # "shuttle",
    # "39-ecoli",                                             
    # "91-soybean-small",                                     
    # "545-rice-cammeo-and-osmancik",                         
    # "602-dry-bean-dataset",                                 
    # "facebook_live_sellers",
    "fashion_mnist",
    "240-human-activity-recognition-using-smartphones",

    # # "236-seeds",
    # "seeds",
    # # "42-glass-identification",
    # "glass",
    # # "scadi",
    # "446-scadi",
    # # "571-hcv-data",
    # "hcv",
    # # "110-yeast",
    # "yeast",
    # # "50-image-segmentation",
    # "image_segmentation",
    # # "107-waveform-database-generator-version-1",
    # "waveform",
    # "pendigits",
    # # "81-pen-based-recognition-of-handwritten-digits",
    # "letter_recognition",
    # # "59-letter-recognition",
    # # "80-optical-recognition-of-handwritten-digits",
    # "handwritten_digits",
    # # "342-mice-protein-expression",
    # "mice_protein",
    # # "159-magic-gamma-telescope",
    # "magic",
    # # "148-statlog-shuttle",
    # "shuttle",
    # "240-human-activity-recognition-using-smartphones",
    # # "human_activity_recognition",

    # "42-glass-identification",                              # | MINMAX NOT THAT GOOD BUT WORKS
    # "facebook_live_sellers" => "Facebook Live Sellers \\citep{dehouche2018facebook}",
    # "80-optical-recognition-of-handwritten-digits",         # | ADD - MINMAX
    # "571-hcv-data",                                         # | ADD - MINMAX
    # "240-human-activity-recognition-using-smartphones",     # | ?
    # "50-image-segmentation",                                # | ADD - MINMAX
    # "52-ionosphere",                                        # | ADD - MINMAX
    # "53-iris",                                              # | ADD - MINMAX NOT THAT GOOD BUT WORKS
    # "59-letter-recognition",                                # | ADD - MINMAX NOT THAT GOOD BUT WORKS
    # "159-magic-gamma-telescope",                            # | ADD - MINMAX
    # "342-mice-protein-expression",                          # | ADD - MINMAX
    # "81-pen-based-recognition-of-handwritten-digits",       # | ADD - MINMAX
    # "236-seeds",                                            # | ADD - MINMAX
    # "95-spect-heart",                                       # | ADD - MINMAX
    # "148-statlog-shuttle",                                  # | ADD - MINMAX
    # "292-wholesale-customers",                              # | ADD
    # "109-wine",                                             # | ADD - MINMAX
    # "110-yeast",                                            # | ADD - MINMAX
    # "107-waveform-database-generator-version-1",            # | ADD - MINMAX
    # "446-scadi",                                            # | ADD - MINMAX
    # "fashion_mnist",
    # PAPER #
    # NEW DATASETS #
    # "39-ecoli",                                             # | ADD - MINMAX
    # "91-soybean-small",                                     # | ADD - MINMAX
    # "545-rice-cammeo-and-osmancik",                         # | ADD - MINMAX
    # "602-dry-bean-dataset",                                 # | ADD - MINMAX
    # NEW DATASETS #
]

const uci_translation = Dict(
    "facebook_live_sellers" => "Facebook Live Sellers \\citep{dehouche2018facebook}",
    "80-optical-recognition-of-handwritten-digits" => "Optical Recognition of Handwritten Digits \\citep{misc_optical_recognition_of_handwritten_digits_80}   ",
    "571-hcv-data" => "HCV Data \\citep{misc_hcv_data_571}",
    "240-human-activity-recognition-using-smartphones" => "Human Activity Recognition \\citep{misc_human_activity_recognition_using_smartphones_240}",
    "50-image-segmentation" => "Image Segmentation \\citep{misc_image_segmentation_50}",
    "52-ionosphere" => "Ionosphere \\citep{misc_ionosphere_52}",
    "53-iris" => "Iris \\citep{misc_iris_53}",
    "59-letter-recognition" => "Letter Recognition \\citep{misc_letter_recognition_59}",
    "159-magic-gamma-telescope" => "MAGIC Gamma Telescope \\citep{misc_magic_gamma_telescope_159}",
    "342-mice-protein-expression" => "Mice Protein Expression \\citep{misc_mice_protein_expression_342}",
    "81-pen-based-recognition-of-handwritten-digits" => "Pen-Based Recognition of Handwritten Digits \\citep{misc_pen-based_recognition_of_handwritten_digits_81}",
    "236-seeds" => "Seeds \\citep{misc_seeds_236}",
    "95-spect-heart" => "SPECT Heart \\citep{misc_spect_heart_95}",
    "148-statlog-shuttle" => "Statlog (Shuttle) \\citep{misc_statlog_(shuttle)_148}",
    "292-wholesale-customers" => "Wholesale Customers \\citep{misc_wholesale_customers_292}",
    "109-wine" => "Wine \\citep{misc_wine_109}",
    "110-yeast" => "Yeast \\citep{misc_yeast_110}",
    "107-waveform-database-generator-version-1" => "Waveform Database Generator (Version 1) \\citep{misc_waveform_database_generator_(version_1)_107}",
    "446-scadi" => "Scadi \\citep{misc_scadi_446}",
    "42-glass-identification" => "Glass Identification \\citep{misc_glass_identification_42}",
    "fashion_mnist" => "Fashion MNIST (Test) \\citep{xiao2017online}",
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
    verbose = options["verbose"]

    # precompile
    run(benchmark, 3, 2, -0.26, 1, tolerance, maxiterations, false)
    clean!(benchmark)

    for k in options["k"]
        for c in options["c"]
            for d in options["d"]
                for i in options["i"]
                    run(benchmark, k, d, c, i, tolerance, maxiterations, verbose)
                end
                save(benchmark, "..", filename)
            end
        end
    end

    datasets_str = join(options["datasets"], ",")
    filename = "uci-[$datasets_str]-[$i_str]-$timestamp"

    if options["uci"]
        for dataset in uci_datasets
            run(benchmark, dataset, options["i"], tolerance, maxiterations, verbose)
            save(benchmark, "..", filename)
        end
    end
end

include("main.jl")

end
