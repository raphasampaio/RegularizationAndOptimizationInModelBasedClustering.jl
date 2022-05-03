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

			# dt = fit(ZScoreTransform, X, dims=1)
			# X = StatsBase.transform(dt, X)

# 			for i in 1:d
# @show				stddev = std(X[:, i])

# 				# if isnan(stddev) || stddev == 0
# 				# 	error("NaN")
# 				# end
# 				# for j in 1:n
# 				# 	X[j, i] = X[j, i] / stddev
# 				# end
# 			end

			return new(string(path), k, X, expected)
		end
	end
end