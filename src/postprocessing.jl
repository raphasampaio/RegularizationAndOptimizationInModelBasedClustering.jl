function to_string(x, fmt)
    return Printf.format(Printf.Format(fmt), x)
end

function linear_interpolation(p::Float64, p_min::Float64, p_max::Float64, i_min::Float64, i_max::Float64)
    return i_min + (((p - p_min) * (i_max - i_min)) / (p_max - p_min))
end

function get_greyscale(v, min, max)
    a = linear_interpolation(v, min, max, 1.0, 0.75)
    return hex(RGB(a, a, a))
end

function uci()
    algorithms = [
        "kmeans", 
        "kmeans_hg", 
        "gmm", 
        "gmm_ms", 
        "gmm_rs", 
        "gmm_hg", 
        "gmm_shrunk", 
        "gmm_ms_shrunk",
        "gmm_rs_shrunk", 
        "gmm_hg_shrunk"
    ]

    results = CSV.read(joinpath("results", "uci.csv"), DataFrame)

    println(raw"""
\begin{table}[htbp]
\centering
\scalebox{0.9}
{
\begin{tabular}{@{}c|l|rrr@{}}
\toprule
\multicolumn{1}{c|}{\#} & \multicolumn{1}{c|}{Dataset} & \multicolumn{1}{c}{\textit{n}} & \multicolumn{1}{c}{\textit{k}} & \multicolumn{1}{c}{\textit{d}} \\ \midrule""")
for (i, dataset) in enumerate(sort(uci_datasets))
    n = filter(row -> row.dataset == dataset, results).n[1]
    k = filter(row -> row.dataset == dataset, results).k[1]
    d = filter(row -> row.dataset == dataset, results).d[1]
    println("\\texttt{$('@' + i)} & $(uci_translation[dataset]) & $n & $k & $d \\\\")
end
println(raw"""
\bottomrule
\end{tabular}
}
\caption{UCI datasets labels and dimensions}
\label{uci_dimensions}
\end{table}
""")
    
println(raw"""
\begin{table}[htbp]
\centering
\scalebox{0.9}
{
\begin{tabular}{@{}c|cccccccccc@{}}
\toprule
\multirow{3}{*}{\#} & k-means & k-means & GMM & GMM & GMM & GMM & GMM   & GMM    & GMM    & GMM    \\
                    &         & HG      &     & MS  & RS  & HG  &        & MS     & RS     & HG     \\
                    &         &         &     &     &     &     & Shrunk & Shrunk & Shrunk & Shrunk \\ \midrule 
""")

    for (i, dataset) in enumerate(sort(uci_datasets))
        print("\\texttt{$('@' + i)}")

        data = Vector{Float64}()
        for algorithm in algorithms
            df = filter(row -> row.dataset == dataset && row.algorithm == algorithm, results)
            push!(data, round(Statistics.mean(df.ari); digits = 2))
        end

        min, min_j = findmin(data)
        max, max_j = findmax(data)

        for j in eachindex(data)
            v = @sprintf "%.2f" data[j]
            hex = get_greyscale(data[j], min, max)
            if j == max_j || max == data[j]
                print(" & \\cellcolor[HTML]{$hex}\\textbf{$v}")
            else
                print(" & \\cellcolor[HTML]{$hex}$v")
            end
        end
        println(" \\\\")
    end
    print(raw"""
\midrule
\multicolumn{1}{c|}{Avg.}""")

data = Vector{Float64}()
for algorithm in algorithms
    df = filter(row -> row.algorithm == algorithm, results)
    push!(data, round(Statistics.mean(df.ari); digits = 2))
end

min, min_j = findmin(data)
max, max_j = findmax(data)

for j in eachindex(data)
    v = @sprintf "%.2f" data[j]
    hex = get_greyscale(data[j], min, max)
    if j == max_j || max == data[j]
        print(" & \\cellcolor[HTML]{$hex}\\textbf{$v}")
    else
        print(" & \\cellcolor[HTML]{$hex}$v")
    end
end
println(" \\\\")

println(raw"""
\bottomrule
\end{tabular}
}
\caption{Accuracy (ARI) comparison on the UCI datasets}
\label{uci_ari}
\end{table}
""")

    formats = Dict(
        "kmeans" => "%.2f", 
        "kmeans_hg" => "%.2f",
        "gmm" => "%.2f",
        "gmm_ms" => "%.2f",
        "gmm_rs" => "%.2f",
        "gmm_hg" => "%.2f",
        "gmm_shrunk" => "%.2f",
        "gmm_ms_shrunk" => "%.2f",
        "gmm_rs_shrunk" => "%.2f",
        "gmm_hg_shrunk" => "%.2f"
    )

println(raw"""
\begin{table}[htbp]
\centering
\scalebox{0.9}
{
\begin{tabular}{@{}c|cccccccccc@{}}
\toprule
\multirow{3}{*}{\#} & k-means & k-means & GMM & GMM & GMM & GMM & GMM   & GMM    & GMM    & GMM    \\
                    &         & HG      &     & MS  & RS  & HG  &        & MS     & RS     & HG     \\
                    &         &         &     &     &     &     & Shrunk & Shrunk & Shrunk & Shrunk \\ \midrule""")

    for (i, dataset) in enumerate(sort(uci_datasets))
        print("\\texttt{$('@' + i)}")

        for algorithm in algorithms
            df = filter(row -> row.dataset == dataset && row.algorithm == algorithm, results)
            v = to_string(ceil(Statistics.mean(df.t); digits = 2), formats[algorithm]) 
            print("& \$$v\$ ")
        end
        println("\\\\")
    end

    print(raw"""
\midrule
\multicolumn{1}{c|}{Avg.}""")

for algorithm in algorithms
    df = filter(row -> row.algorithm == algorithm, results)
    v = to_string(ceil(Statistics.mean(df.t); digits = 2), formats[algorithm]) 
    print("& \$$v\$ ")
end

println(raw"""
\\ \bottomrule
\end{tabular}
}
\caption{CPU time (s) comparison on the UCI datasets}
\label{uci_cpu}
\end{table}
""")
end

function wilcoxon()
    results = CSV.read(joinpath("results", "synthetical.csv"), DataFrame)
    sort!(results, [:algorithm, :k, :c, :d, :i])
    # filter!(row -> row.k == 10 && row.c == 0.01, results)

    println("""
\\begin{table}[htbp]
\\centering
\\scalebox{0.9}
{
\\begin{tabular}{l@{\\hspace{1cm}}l}
\\toprule
\\textbf{Pair of methods} & \\textbf{p-value} \\\\
\\midrule""")

    for algorithm in ["gmm", "gmm_oas", "gmm_ledoitwolf"]
        df1 = filter(row -> row.algorithm == algorithm, results)
        df2 = filter(row -> row.algorithm == "gmm_shrunk", results)

        v = @sprintf "%.2E" pvalue(SignedRankTest(df1.ari, df2.ari))
        str = replace(v, "E" => "\\times 10^{") * "}"
        println("GMM Shrunk -- $(translation[algorithm]) & \$$str\$ \\\\")
    end

    println("""
\\bottomrule
\\end{tabular}
}
\\caption{Impact of regularization on GMM: Pairwise Wilcoxon tests}
\\label{tab:wilcoxon1}
\\end{table}
""")

    println("""
\\begin{table}[htbp]
\\centering
\\scalebox{0.9}
{
\\begin{tabular}{l@{\\hspace{1cm}}l}
\\toprule
\\textbf{Algorithm} & \\textbf{p-value} \\\\
\\midrule""")

    for algorithm in ["kmeans", "kmeans_hg", "gmm"]
        df1 = filter(row -> row.algorithm == algorithm, results)
        df2 = filter(row -> row.algorithm == "gmm_hg_shrunk", results)

        v = @sprintf "%.2E" pvalue(SignedRankTest(df1.ari, df2.ari))
        str = replace(v, "E" => "\\times 10^{") * "}"
        println("GMM HG Shrunk -- $(translation[algorithm]) & \$$str\$ \\\\")
    end

    println("""
\\bottomrule
\\end{tabular}
}
\\caption{Comparison with k-means, k-means HG and GMM: Pairwise Wilcoxon tests}
\\label{tab:wilcoxon2}
\\end{table}
""")

results = CSV.read(joinpath("results", "uci.csv"), DataFrame)
sort!(results, [:algorithm, :dataset, :i])

println("""
\\begin{table}[htbp]
\\centering
\\scalebox{0.9}
{
\\begin{tabular}{l@{\\hspace{1cm}}l}
\\toprule
\\textbf{Algorithm} & \\textbf{p-value} \\\\
\\midrule""")

    for algorithm in ["kmeans", "kmeans_hg", "gmm", "gmm_ms", "gmm_rs", "gmm_hg", "gmm_shrunk", "gmm_ms_shrunk", "gmm_rs_shrunk"]
        df1 = filter(row -> row.algorithm == algorithm, results)
        df2 = filter(row -> row.algorithm == "gmm_hg_shrunk", results)

        v = @sprintf "%.2E" pvalue(SignedRankTest(df1.ari, df2.ari))
        str = replace(v, "E" => "\\times 10^{") * "}"
        println("GMM HG Shrunk -- $(translation[algorithm]) & \$$str\$ \\\\")
    end

    println("""
\\bottomrule
\\end{tabular}
}
\\caption{Comparison with k-means, k-means HG and GMM variations: Pairwise Wilcoxon tests}
\\label{tab:wilcoxon3}
\\end{table}
""")

end

function cpu_time()
    algorithms = [
        "kmeans", 
        "kmeans_hg", 
        "gmm", 
        "gmm_ms", 
        "gmm_rs", 
        "gmm_hg", 
        "gmm_shrunk", 
        "gmm_ms_shrunk",
        "gmm_rs_shrunk", 
        "gmm_hg_shrunk"
    ]

    formats = Dict(
        "kmeans" => "%.2f", 
        "kmeans_hg" => "%.2f",
        "gmm" => "%.2f",
        "gmm_ms" => "%.2f",
        "gmm_rs" => "%.2f",
        "gmm_hg" => "%.2f",
        "gmm_shrunk" => "%.2f",
        "gmm_ms_shrunk" => "%.2f",
        "gmm_rs_shrunk" => "%.2f",
        "gmm_hg_shrunk" => "%.2f"
    )

    results = CSV.read(joinpath("results", "synthetical.csv"), DataFrame)
    sort!(results, [:algorithm, :k, :c, :d, :i])

println(raw"""
\begin{table}[htbp]
\centering
\scalebox{0.9}
{
\begin{tabular}{@{}c|cccccccccc@{}}
\toprule
\multirow{3}{*}{k} & k-means & k-means & GMM & GMM & GMM & GMM & GMM & GMM & GMM & GMM \\
 &  & HG &  & MS & RS & HG &  & MS & RS & HG \\
 &  &  &  &  &  &  & Shrunk & Shrunk & Shrunk & Shrunk \\ \midrule""")

for k in [3, 10, 20]
    print("$k ")
    for algorithm in algorithms
        df = filter(row -> row.k == k && row.algorithm == algorithm, results)
        v = to_string(ceil(Statistics.mean(df.t); digits = 2), formats[algorithm]) 
        print("& \$$v\$ ")
    end
    println("\\\\")
end
println("\\midrule")

print("Avg. ")
for algorithm in algorithms
    df = filter(row -> row.algorithm == algorithm, results)
    v = to_string(ceil(Statistics.mean(df.t); digits = 2), formats[algorithm]) 
    print("& \$$v\$ ")
end
println("\\\\ \\bottomrule")

println(raw"""\end{tabular}
}
\caption{Average CPU time in seconds, for a different target number of clusters}
\label{cputime1}
\end{table}

\begin{table}[htbp]
\centering
\scalebox{0.9}
{
\begin{tabular}{@{}c|cccccccccc@{}}
\toprule
\multirow{3}{*}{d} & k-means & k-means & GMM & GMM & GMM & GMM & GMM & GMM & GMM & GMM \\
 &  & HG &  & MS & RS & HG &  & MS & RS & HG \\
 &  &  &  &  &  &  & Shrunk & Shrunk & Shrunk & Shrunk \\ \midrule""")

for d in [2, 5, 10, 20, 30, 40]
    print("$d ")
    for algorithm in algorithms
        df = filter(row -> row.d == d && row.algorithm == algorithm, results)
        v = to_string(Statistics.mean(df.t), formats[algorithm]) 
        print("& \$$v\$ ")
    end
    println("\\\\")
end
println("\\midrule")

print("Avg. ")
for algorithm in algorithms
    df = filter(row -> row.algorithm == algorithm, results)
    v = to_string(Statistics.mean(df.t), formats[algorithm]) 
    print("& \$$v\$ ")
end
println("\\\\ \\bottomrule")

println(raw"""\end{tabular}
}
\caption{Average CPU time in seconds, for different number of features}
\label{cputime2}
\end{table}
""")

end