using DelimitedFiles

@enum DatasetNorm DatasetNormNone DatasetNormMinMax DatasetNormZScore

struct Dataset
    path::String
    k::Int
    X::Matrix{Float64}
    expected::Array{Int}

    function Dataset(path::String, norm::DatasetNorm)
        open(path) do file
            table = readdlm(file, ',')

            n = size(table, 1)
            d = size(table, 2) - 1

            clusters = Set{Int}()
            expected = zeros(Int, n)

            for i in 1:n
                expected[i] = Int(table[i, 1])
                push!(clusters, expected[i])
            end
            k = length(clusters)

            X = table[:, 2:size(table, 2)]

            # tmin, tmax = StatsBase._compute_extrema(X, 1)
            # @show tmin
            # @show tmax

            if norm == DatasetNormMinMax
                X = standardize(UnitRangeTransform, X, dims=1)
            elseif norm == DatasetNormZScore
                X = standardize(ZScoreTransform, X, dims=1)
            end

            # tmin, tmax = StatsBase._compute_extrema(X, 1)
            # @show tmin
            # @show tmax

            for i in 1:d
                if any(isnan.(X[:, i]))
                    @show i
                    @show maximum(X[:, i])
                    @show minimum(X[:, i])
                    error("NaN")
                end
            end

            return new(string(path), k, X, expected)
        end
    end
end
