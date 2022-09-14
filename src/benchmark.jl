mutable struct Benchmark
    syn::DataFrame
    uci::DataFrame
    algorithms::Vector{Function}

    function Benchmark()
        syn = DataFrame(
            algorithm = Symbol[],
            k = Int[],
            c = Float64[],
            d = Int[],
            i = Int[],
            ari = Float64[],
            t = Float64[],
        )
        uci = DataFrame(
            algorithm = Symbol[],
            dataset = Symbol[],
            n = Int[],
            k = Int[],
            d = Int[],
            ari = Float64[],
            t = Float64[],
        )
        return new(syn, uci, Vector{Function}())
    end
end

function Base.push!(benchmark::Benchmark, algorithm::Function)
    push!(benchmark.algorithms, algorithm)
    return nothing
end

function clean!(benchmark::Benchmark)
    deleteat!(benchmark.syn, [1:nrow(benchmark.syn);])
    deleteat!(benchmark.uci, [1:nrow(benchmark.uci);])
    return nothing
end

function run(benchmark::Benchmark, k::Int, d::Int, c::Float64, i::Int)
    for algorithm in benchmark.algorithms
        file = "$(k)_$(d)_$(c)_$(i)"
        dataset = Dataset(joinpath("data", "$file.csv"))

        Random.seed!(1)
        t = @elapsed result = algorithm(dataset.X, dataset.k)
        ari = Clustering.randindex(dataset.expected, result.assignments)[1]
        # pvalue = HypothesisTests.pvalue(ExactSignedRankTest(dataset.expected, result.assignments))

        push!(benchmark.syn, (Symbol(algorithm), k, c, d, i, ari, t))
    end
end

function run(benchmark::Benchmark, file::String)
    for algorithm in benchmark.algorithms
        dataset = Dataset(joinpath("data", "uci", "$file.csv"))
        n = size(dataset.X, 1)
        k = dataset.k
        d = size(dataset.X, 2)

        Random.seed!(1)
        t = @elapsed result = algorithm(dataset.X, dataset.k)
        ari = Clustering.randindex(dataset.expected, result.assignments)[1]
        # pvalue = HypothesisTests.pvalue(ExactSignedRankTest(dataset.expected, result.assignments))

        println("$file, $algorithm, $ari, $t")
        push!(benchmark.uci, (Symbol(algorithm), Symbol(file), n, k, d, ari, t))
    end
end

function save(benchmark::Benchmark, path::String, filename::String)
    if !isdir(path)
        mkdir(path)
    end

    if size(benchmark.syn, 1) > 0
        @show benchmark.syn
        CSV.write("$(joinpath(path, "$filename.csv"))", benchmark.syn)
    end

    if size(benchmark.uci, 1) > 0
        @show benchmark.uci
        CSV.write("$(joinpath(path, "$filename.csv"))", benchmark.uci)
    end
    return nothing
end
