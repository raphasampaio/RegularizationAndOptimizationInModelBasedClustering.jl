# function van_dongen_criterion(labels_true::Vector{Int}, labels_pred::Vector{Int})
#     n = length(labels_true)
#     @show count_pairs = StatsBase.countmap(zip(labels_true, labels_pred))
#     @show unique(labels_pred)
#     tp = sum(maximum(count_pairs[:, i]) for i in unique(labels_pred))
#     fp = sum(count_pairs[i, j] - maximum(count_pairs[i, :]) for i in unique(labels_true), j in unique(labels_pred))
#     fn = sum(count_pairs[i, j] - maximum(count_pairs[:, j]) for i in unique(labels_true), j in unique(labels_pred))
#     tn = n - tp - fp - fn
#     return (tp + tn) / (tp + fp + fn + tn)
# end

# function accuracy_score(y_true::Vector{Int}, y_pred::Vector{Int})
#     n = length(y_true)
#     correct = 0
#     for (yt, yp) in zip(y_true, y_pred)
#         if yt == yp
#             correct += 1
#         end
#     end
#     return correct / n
# end

function orphans_count(data::AbstractMatrix{<:Real}, k::Integer, a::AbstractVector{<:Integer}, b::AbstractVector{<:Integer})
    centroids_a = [mean(data[a .== i, :], dims = 1) for i in 1:k]
    centroids_b = [mean(data[b .== i, :], dims = 1) for i in 1:k]

    # find nearest centroids 
    nearest_centroids = zeros(Int, k)
    for i in 1:k
        distances = zeros(k)
        for j in 1:k
            distances[j] = norm(centroids_a[i, :] - centroids_b[j, :])
        end

        nearest_centroids[i] = findmin(distances)[2]
    end

    in_degree = [count(j -> j == i, nearest_centroids) for i in 1:k]

    # detect prototypes with no mapping
    orphans = zeros(Int, k)
    for i in 1:k
        if in_degree[i] == 0
            orphans[i] = 1
        end
    end

    return sum(orphans)
end

function centroid_index(data::AbstractMatrix{<:Real}, k::Integer, a::AbstractVector{<:Integer}, b::AbstractVector{<:Integer})
    centroid_index1 = orphans_count(data, k, a, b)
    centroid_index2 = orphans_count(data, k, b, a)
    return max(centroid_index1, centroid_index2)
end

struct Evaluation
    ari::Float64
    nmi::Float64
    ci::Int

    mirkins_index::Float64
    huberts_index::Float64
    varinfo::Float64
    vmeasure::Float64
    
    function Evaluation(data::AbstractMatrix{<:Real}, k::Integer, a::AbstractVector{<:Integer}, b::AbstractVector{<:Integer})
        ri = Clustering.randindex(a, b)

        ari = ri[1]
        nmi = Clustering.mutualinfo(a, b, normed = true)
        ci = centroid_index(data, k, a, b)

        mirkins_index = ri[3]
        huberts_index = ri[4]
        varinfo = Clustering.varinfo(a, b)
        vmeasure = Clustering.vmeasure(a, b)

        return new(
            ari, 
            nmi,
            ci,
            mirkins_index,
            huberts_index,
            varinfo,
            vmeasure,
        )
    end
end