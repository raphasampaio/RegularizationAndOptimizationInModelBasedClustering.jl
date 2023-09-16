function find_nearest_centroids(c_a, c_b)
    k = length(c_a)

    nearest_centroids = zeros(Int, k)
    for i in 1:k
        distances = zeros(k)
        for j in 1:k
            distances[j] = norm(c_a[i, :] - c_b[j, :])
        end

        nearest_centroids[i] = findmin(distances)[2]
    end
    return nearest_centroids, k
end

function find_nearest_centroids(c_a, sigma_a, c_b, sigma_b)
    k = length(c_a)

    nearest_centroids = zeros(Int, k)
    for i in 1:k
        distances = zeros(k)
        for j in 1:k
            sigma = (sigma_a[i] + sigma_b[j]) / 2.0

            try
                distances[j] = ((c_a[i] - c_b[j])' * inv(sigma) * (c_a[i] - c_b[j])) / 8.0 + (log(det(sigma) / sqrt(det(sigma_a[i]) * det(sigma_b[j])))) / 2.0
            catch 
                distances[j] = Inf
            end
        end

        nearest_centroids[i] = findmin(distances)[2]
    end
    return nearest_centroids, k
end

function orphans_count(args...)
    nearest_centroids, k = find_nearest_centroids(args...)

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

function centroid_index(c_a, c_b)
    centroid_index1 = orphans_count(c_a, c_b)
    centroid_index2 = orphans_count(c_b, c_a)
    return max(centroid_index1, centroid_index2)
end

function centroid_index(c_a, sigma_a, c_b, sigma_b)
    centroid_index1 = orphans_count(c_a, sigma_a, c_b, sigma_b)
    centroid_index2 = orphans_count(c_b, sigma_b, c_a, sigma_a)
    return max(centroid_index1, centroid_index2)
end

function centroid_index_sphere(dataset::Dataset, result::UnsupervisedClustering.KmeansResult)
    k = dataset.k
    c_a = [mean(dataset.X[dataset.expected .== i, :], dims = 1) for i in 1:k]
    c_b = [result.centers[:, i]' for i in 1:k]
    return centroid_index(c_a, c_b)
end

function centroid_index_sphere(dataset::Dataset, result::UnsupervisedClustering.GMMResult)
    k = dataset.k
    c_a = [mean(dataset.X[dataset.expected .== i, :], dims = 1) for i in 1:k]
    c_b = [result.centers[i]' for i in 1:k]
    return centroid_index(c_a, c_b)
end

function get_covariance_and_center(dataset::Dataset)
    k = dataset.k

    sigma = Vector{Matrix{Float64}}()
    c = Vector{Vector{Float64}}()
    for i in 1:k
        data = dataset.X[dataset.expected .== i, :]
        n, d = size(data)

        covariance, center = RegularizedCovarianceMatrices.fit(EmpiricalCovarianceMatrix(n, d), data)

        push!(sigma, covariance)
        push!(c, center)
    end

    return sigma, c
end

function centroid_index_ellipsoid(dataset::Dataset, result::UnsupervisedClustering.KmeansResult)
    k = dataset.k
    n, d = size(dataset.X)

    sigma_a, c_a = get_covariance_and_center(dataset)
    
    sigma_b = [Matrix{Float64}(I, d, d) for i in 1:k]
    c_b = [result.centers[:, i]' for i in 1:k]

    return centroid_index(c_a, sigma_a, c_b, sigma_b)
end

function centroid_index_ellipsoid(dataset::Dataset, result::UnsupervisedClustering.GMMResult)
    k = dataset.k

    sigma_a, c_a = get_covariance_and_center(dataset)
    
    sigma_b = [result.covariances[i] for i in 1:k]
    c_b = [result.centers[i] for i in 1:k]

    return centroid_index(c_a, sigma_a, c_b, sigma_b)
end

function norm_matrix(m::AbstractMatrix{<:Number})
    d = size(m, 1)
    determinant = det(m)
    return m / ((determinant > 0 ? determinant : 1.0)^(1 / d))
end

function centroid_index_ellipsoid_norm(dataset::Dataset, result::UnsupervisedClustering.KmeansResult)
    k = dataset.k
    n, d = size(dataset.X)

    sigma_a, c_a = get_covariance_and_center(dataset)
    
    sigma_b = [Matrix{Float64}(I, d, d) for i in 1:k]
    c_b = [result.centers[:, i]' for i in 1:k]

    sigma_a = [norm_matrix(sigma_a[i]) for i in 1:k]
    sigma_b = [norm_matrix(sigma_b[i]) for i in 1:k]

    return centroid_index(c_a, sigma_a, c_b, sigma_b)
end

function centroid_index_ellipsoid_norm(dataset::Dataset, result::UnsupervisedClustering.GMMResult)
    k = dataset.k
    n, d = size(dataset.X)

    sigma_a, c_a = get_covariance_and_center(dataset)
    
    sigma_b = [result.covariances[i] for i in 1:k]
    c_b = [result.centers[i] for i in 1:k]

    sigma_a = [norm_matrix(sigma_a[i]) for i in 1:k]
    sigma_b = [norm_matrix(sigma_b[i]) for i in 1:k]

    return centroid_index(c_a, sigma_a, c_b, sigma_b)
end

function centroid_index_mixture(dataset::Dataset, result::UnsupervisedClustering.Result)
    if result isa UnsupervisedClustering.KmeansResult
        return centroid_index_sphere(dataset, result)
    elseif result isa UnsupervisedClustering.GMMResult
        return centroid_index_ellipsoid(dataset, result)
    else
        throw(ArgumentError("Unsupported result type"))
    end
end

function centroid_index_mixture_norm(dataset::Dataset, result::UnsupervisedClustering.Result)
    if result isa UnsupervisedClustering.KmeansResult
        return centroid_index_sphere(dataset, result)
    elseif result isa UnsupervisedClustering.GMMResult
        return centroid_index_ellipsoid_norm(dataset, result)
    else
        throw(ArgumentError("Unsupported result type"))
    end
end

Base.@kwdef struct Evaluation
    ari::Float64
    nmi::Float64
    ci_sphere::Int
    ci_ellipsoid::Int
    ci_ellipsoid_norm::Int
    ci_mixture::Int
    ci_mixture_norm::Int

    mirkins_index::Float64
    huberts_index::Float64
    varinfo::Float64
    vmeasure::Float64
end

function Evaluation(dataset::Dataset, result::UnsupervisedClustering.Result)
    ri = Clustering.randindex(dataset.expected, result.assignments)

    return Evaluation(
        ari = ri[1], 
        nmi = Clustering.mutualinfo(dataset.expected, result.assignments, normed = true),
        ci_sphere = centroid_index_sphere(dataset, result),
        ci_ellipsoid = centroid_index_ellipsoid(dataset, result),
        ci_ellipsoid_norm = centroid_index_ellipsoid_norm(dataset, result),
        ci_mixture = centroid_index_mixture(dataset, result),
        ci_mixture_norm = centroid_index_mixture_norm(dataset, result),
        mirkins_index = ri[3],
        huberts_index = ri[4],
        varinfo = Clustering.varinfo(dataset.expected, result.assignments),
        vmeasure = Clustering.vmeasure(dataset.expected, result.assignments),
    )
end