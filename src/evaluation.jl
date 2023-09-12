function orphans_count(centroids_a, centroids_b)
    k = length(centroids_a)

    # centroids_a = [mean(data[a .== i, :], dims = 1) for i in 1:k]
    # centroids_b = [mean(data[b .== i, :], dims = 1) for i in 1:k]

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

function centroid_index(centroids_a, centroids_b)
    centroid_index1 = orphans_count(centroids_a, centroids_b)
    centroid_index2 = orphans_count(centroids_b, centroids_a)
    return max(centroid_index1, centroid_index2)
end

Base.@kwdef struct Evaluation
    ari::Float64
    nmi::Float64
    ci::Int

    mirkins_index::Float64
    huberts_index::Float64
    varinfo::Float64
    vmeasure::Float64
end
    
function Evaluation(dataset::Dataset, result::UnsupervisedClustering.KmeansResult)
    k = dataset.k

    ri = Clustering.randindex(dataset.expected, result.assignments)

    centroids_a = [mean(dataset.X[dataset.expected .== i, :], dims = 1) for i in 1:k]
    centroids_b = [result.centers[:, i]' for i in 1:k]

    return Evaluation(
        ari = ri[1], 
        nmi = Clustering.mutualinfo(dataset.expected, result.assignments, normed = true),
        ci = centroid_index(centroids_a, centroids_b),
        mirkins_index = ri[3],
        huberts_index = ri[4],
        varinfo = Clustering.varinfo(dataset.expected, result.assignments),
        vmeasure = Clustering.vmeasure(dataset.expected, result.assignments),
    )
end

function Evaluation(dataset::Dataset, result::UnsupervisedClustering.GMMResult)
    k = dataset.k

    ri = Clustering.randindex(dataset.expected, result.assignments)

    centroids_a = [mean(dataset.X[dataset.expected .== i, :], dims = 1) for i in 1:k]
    centroids_b = [result.centers[i]' for i in 1:k]

    return Evaluation(
        ari = ri[1], 
        nmi = Clustering.mutualinfo(dataset.expected, result.assignments, normed = true),
        ci = centroid_index(centroids_a, centroids_b),
        mirkins_index = ri[3],
        huberts_index = ri[4],
        varinfo = Clustering.varinfo(dataset.expected, result.assignments),
        vmeasure = Clustering.vmeasure(dataset.expected, result.assignments),
    )
end