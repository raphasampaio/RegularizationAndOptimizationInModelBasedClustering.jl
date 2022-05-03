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

            return new(string(path), k, X, expected)
        end
    end
end
