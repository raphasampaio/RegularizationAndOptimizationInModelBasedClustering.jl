mutable struct Benchmark
    syn::DataFrame
    uci::DataFrame
    symbols::Vector{Symbol}

    function Benchmark()
        syn = DataFrame(
            algorithm = Symbol[],
            k = Int[],
            c = Float64[],
            d = Int[],
            i = Int[],
            ari = Float64[],
            nmi = Float64[],
            ci_sphere = Int[],
            ci_ellipsoid = Int[],
            ci_ellipsoid_norm = Int[],
            ci_mixture = Int[],
            ci_mixture_norm = Int[],
            mirkins_index = Float64[],
            huberts_index = Float64[],
            varinfo = Float64[],
            vmeasure = Float64[],
            obj = Float64[],
            t = Float64[],
        )
        uci = DataFrame(
            algorithm = Symbol[],
            dataset = Symbol[],
            n = Int[],
            k = Int[],
            d = Int[],
            i = Int[],
            ari = Float64[],
            nmi = Float64[],
            ci_sphere = Int[],
            ci_ellipsoid = Int[],
            ci_ellipsoid_norm = Int[],
            ci_mixture = Int[],
            ci_mixture_norm = Int[],
            mirkins_index = Float64[],
            huberts_index = Float64[],
            varinfo = Float64[],
            vmeasure = Float64[],
            obj = Float64[],
            t = Float64[],
        )
        return new(syn, uci, Vector{Function}())
    end
end

function Base.push!(benchmark::Benchmark, symbol::Symbol)
    push!(benchmark.symbols, symbol)
    return nothing
end

function clean!(benchmark::Benchmark)
    deleteat!(benchmark.syn, [1:nrow(benchmark.syn);])
    deleteat!(benchmark.uci, [1:nrow(benchmark.uci);])
    return nothing
end

function get_algorithm(
    algorithm::Symbol,
    n::Int,
    d::Int,
    seed::Int,
    tolerance::Float64,
    max_iterations::Int,
    verbose::Bool
)
    kmeans = Kmeans(
        rng = Xoshiro(seed),
        tolerance = tolerance,
        max_iterations = max_iterations,
        verbose = verbose,
    )
    gmm = GMM(
        estimator = EmpiricalCovarianceMatrix(n, d),
        rng = Xoshiro(seed),
        tolerance = tolerance,
        max_iterations = max_iterations,
        verbose = verbose,
    )
    gmm_shrunk = GMM(
        estimator = ShrunkCovarianceMatrix(n, d),
        rng = Xoshiro(seed),
        tolerance = tolerance,
        max_iterations = max_iterations,
        verbose = verbose,
    )
    gmm_oas = GMM(
        estimator = OASCovarianceMatrix(n, d),
        rng = Xoshiro(seed),
        tolerance = tolerance,
        max_iterations = max_iterations,
        verbose = verbose,
    )
    gmm_lw = GMM(
        estimator = LedoitWolfCovarianceMatrix(n, d),
        rng = Xoshiro(seed),
        tolerance = tolerance,
        max_iterations = max_iterations,
        verbose = verbose,
    )

    return if algorithm == :kmeans
        kmeans
    elseif algorithm == :kmeans_ms
        MultiStart(local_search = kmeans, verbose = verbose)
    elseif algorithm == :kmeans_rs
        RandomSwap(local_search = kmeans, verbose = verbose)
    elseif algorithm == :kmeans_hg
        GeneticAlgorithm(local_search = kmeans, verbose = verbose)
    elseif algorithm == :gmm
        gmm
    elseif algorithm == :gmm_ms
        MultiStart(local_search = gmm, verbose = verbose)
    elseif algorithm == :gmm_rs
        RandomSwap(local_search = gmm, verbose = verbose)
    elseif algorithm == :gmm_hg
        GeneticAlgorithm(local_search = gmm, verbose = verbose)
    elseif algorithm == :gmm_shrunk
        gmm_shrunk
    elseif algorithm == :gmm_ms_shrunk
        MultiStart(local_search = gmm_shrunk, verbose = verbose)
    elseif algorithm == :gmm_rs_shrunk
        RandomSwap(local_search = gmm_shrunk, verbose = verbose)
    elseif algorithm == :gmm_hg_shrunk
        GeneticAlgorithm(local_search = gmm_shrunk, verbose = verbose)
    elseif algorithm == :gmm_oas
        gmm_oas
    elseif algorithm == :gmm_ms_oas
        MultiStart(local_search = gmm_oas, verbose = verbose)
    elseif algorithm == :gmm_rs_oas
        RandomSwap(local_search = gmm_oas, verbose = verbose)
    elseif algorithm == :gmm_hg_oas
        GeneticAlgorithm(local_search = gmm_oas, verbose = verbose)
    elseif algorithm == :gmm_ledoitwolf
        gmm_lw
    elseif algorithm == :gmm_ms_ledoitwolf
        MultiStart(local_search = gmm_lw, verbose = verbose)
    elseif algorithm == :gmm_rs_ledoitwolf
        RandomSwap(local_search = gmm_lw, verbose = verbose)
    elseif algorithm == :gmm_hg_ledoitwolf
        GeneticAlgorithm(local_search = gmm_lw, verbose = verbose)
    else
        error("algorithm not found")
    end
end

function run(benchmark::Benchmark, k::Int, d::Int, c::Float64, i::Int, tolerance::Float64, max_iterations::Int, verbose::Bool)
    file = "$(k)_$(d)_$(c)_$(i)"

    for symbol in benchmark.symbols
        path = joinpath("data", "$file.csv")
        dataset = Dataset(path, DatasetNormNone)
        n, d = size(dataset.X)

        algorithm = get_algorithm(symbol, n, d, 123, tolerance, max_iterations, verbose)

        t = @elapsed result = UnsupervisedClustering.fit(algorithm, dataset.X, dataset.k)
        evaluation = Evaluation(dataset, result)
        obj = result.objective

        @printf("%s, %s, %.2f, %.2f, %d, %.2f\n", 
            file,
            symbol,
            evaluation.ari,
            evaluation.nmi,
            evaluation.ci_sphere,
            t
        )

        push!(benchmark.syn, 
            (
                symbol,
                k,
                c,
                d,
                i,
                evaluation.ari,
                evaluation.nmi,
                evaluation.ci_sphere,
                evaluation.ci_ellipsoid,
                evaluation.ci_ellipsoid_norm,
                evaluation.ci_mixture,
                evaluation.ci_mixture_norm,
                evaluation.mirkins_index,
                evaluation.huberts_index,
                evaluation.varinfo,
                evaluation.vmeasure,
                obj,
                t
            )
        )
    end
end

function run(benchmark::Benchmark, file::String, seeds::Vector{Int}, tolerance::Float64, max_iterations::Int, verbose::Bool)
    for symbol in benchmark.symbols
        path = joinpath(raw"/Users/raphasampaio/Developer/Clustering/uci-data/data", "$file.csv")
        dataset = Dataset(path, DatasetNormMinMax)
        n, d = size(dataset.X)
        k = dataset.k

        for seed in seeds
            algorithm = get_algorithm(symbol, n, d, seed, tolerance, max_iterations, verbose)

            t = @elapsed result = UnsupervisedClustering.fit(algorithm, dataset.X, dataset.k)
            evaluation = Evaluation(dataset, result)
            obj = result.objective

            @printf("%s, %s, %d, %.2f, %.2f, %d, %.2f\n", 
                file,
                symbol,
                seed,
                evaluation.ari,
                evaluation.nmi,
                evaluation.ci_sphere,
                t
            )
            
            push!(benchmark.uci, 
                (
                    symbol,
                    Symbol(file),
                    n,
                    k,
                    d,
                    seed,
                    evaluation.ari,
                    evaluation.nmi,
                    evaluation.ci_sphere,
                    evaluation.ci_ellipsoid,
                    evaluation.ci_ellipsoid_norm,
                    evaluation.ci_mixture,
                    evaluation.ci_mixture_norm,
                    evaluation.mirkins_index,
                    evaluation.huberts_index,
                    evaluation.varinfo,
                    evaluation.vmeasure,
                    obj,
                    t
                )
            )
        end
    end
end

function save(benchmark::Benchmark, path::String, filename::String)
    csv_path = joinpath(path, "$filename.csv")

    if size(benchmark.syn, 1) > 0
        CSV.write("$csv_path", benchmark.syn)
    end

    if size(benchmark.uci, 1) > 0
        CSV.write("$csv_path", benchmark.uci)
    end
    return nothing
end
