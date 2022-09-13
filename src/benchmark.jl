mutable struct Benchmark
    df::DataFrame
    uci::DataFrame
    algorithms::Vector{Function}

    function Benchmark()
        # df = DataFrame()
        # insertcols!(df, 1, :name => [])
        # return new(df, Vector{Dataset}(), Vector{Function}())

        df = DataFrame(
            algorithm = Symbol[],
            n = Int[],
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
        return new(df, uci, Vector{Function}())
    end
end

function Base.push!(benchmark::Benchmark, algorithm::Function)
    push!(benchmark.algorithms, algorithm)
    return nothing
end

function clean!(benchmark::Benchmark)
    benchmark.df = DataFrame(
        algorithm = Symbol[],
        n = Int[],
        k = Int[],
        c = Float64[],
        d = Int[],
        i = Int[],
        ari = Float64[],
        t = Float64[],
    )
    benchmark.uci = DataFrame(
        algorithm = Symbol[],
        dataset = Symbol[],
        n = Int[],
        k = Int[],
        d = Int[],
        ari = Float64[],
        t = Float64[],
    )
    return nothing
end

function run(benchmark::Benchmark, n::Int, k::Int, d::Int, c::Float64, i::Int)
    for algorithm in benchmark.algorithms
        file = "$(n)_$(k)_$(d)_$(c)_$(i)"
        dataset = Dataset(joinpath("data", "$file.csv"))

        Random.seed!(1)
        t = @elapsed result = algorithm(dataset.X, dataset.k)
        ari = Clustering.randindex(dataset.expected, result.assignments)[1]

        # @show algorithm, ari, t

        # save(dataset, result, "D:\\Development\\clustering\\img\\$(n)_$(k)_$(d)_$(c)_$(i)_$(algorithm).png")
        # println("$(name)_$i\t$current_ari\t$current_elapsed")

        push!(benchmark.df, (Symbol(algorithm), n, k, c, d, i, ari, t))
    end
end

function run(benchmark::Benchmark, file::String)
    for algorithm in benchmark.algorithms
        dataset = Dataset(joinpath("data", "uci", "$file.csv"))

        Random.seed!(1)
        t = @elapsed result = algorithm(dataset.X, dataset.k)
        ari = Clustering.randindex(dataset.expected, result.assignments)[1]

        println("$file, $algorithm, $ari, $t")

        push!(benchmark.uci, (Symbol(algorithm), Symbol(file), size(dataset.X, 1), dataset.k, size(dataset.X, 2), ari, t))   
    end
end

function save(benchmark::Benchmark, path::String, filename::String)
    if !isdir(path)
        mkdir(path)
    end

    if size(benchmark.df, 1) > 0
        @show benchmark.df
        CSV.write("$(joinpath(path, "$filename.csv"))", benchmark.df)
    end

    if size(benchmark.uci, 1) > 0
        @show benchmark.uci
        CSV.write("$(joinpath(path, "$filename.csv"))", benchmark.uci)
    end
    return nothing
end
