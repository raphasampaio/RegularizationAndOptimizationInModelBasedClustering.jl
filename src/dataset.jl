using DelimitedFiles

struct Dataset
    path::String
    k::Int
    X::Matrix{Float64}
    expected::Array{Int}

    function Dataset(path::String)
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

            # # norm the matrix
            # for i in 1:d
            #     for j in 1:n
            #         X[j, i] = X[j, i] / norm(X[:, i])
            #     end
            #     X[:, i] = (X[:, i] - mean(X[:, i])) / std(X[:, i])
            # end

            # min = minimum(X)
            # max = maximum(X)
            # X = (X .- min) ./ (max - min)

            # μ = mean(X)
            # σ = std(X)
            # X = (X .- μ) ./ σ

            return new(string(path), k, X, expected)
        end
    end
end
