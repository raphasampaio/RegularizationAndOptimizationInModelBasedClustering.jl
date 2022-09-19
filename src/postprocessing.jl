function to_string(x, fmt)
    return Printf.format(Printf.Format(fmt), x)
end

function uci()
    results = CSV.read(joinpath("results", "uci.csv"), DataFrame)
    
println("""
\\begin{table}[htbp]
\\centering
\\scalebox{0.9}
{
\\begin{tabular}{@{}c|cccccccccc@{}}
\\toprule
\\multirow{3}{*}{\\#} & k-means & k-means & GMM & GMM & GMM & GMM & GMM   & GMM    & GMM    & GMM    \\
                    &         & HG      &     & MS  & RS  & HG  &        & MS     & RS     & HG     \\
                    &         &         &     &     &     &     & Shrunk & Shrunk & Shrunk & Shrunk \\ \\midrule 
""")

chars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q"]

    for i in 1:length(uci_datasets)
        dataset = uci_datasets[i]
        println("\\texttt{$(chars[i])} &")

        values = filter(row -> row.dataset == dataset, results).ari
        min = minimum(values)
        max = maximum(values)

        for algorithm in ["kmeans", "kmeans_hg", "gmm"]
            df = filter(row -> row.dataset == dataset && row.algorithm == algorithm, results)
            v = @sprintf "%.2f" Statistics.mean(df.ari)
            println("\\cellcolor[HTML]{F5F5F8}$v &")
        end
        println("\\\\")
    end
    println(
"""
\\bottomrule
\\end{tabular}
}
\\caption{ARI in UCI datasets for multiple methods}
\\label{uci_ari}
\\end{table}
""")
end

function wilcoxon()
    results = CSV.read(joinpath("results", "synthetical-v2.csv"), DataFrame)
    sort!(results, [:algorithm, :k, :c, :d, :i])
    # filter!(row -> row.k == 10 && row.c == 0.01, results)

    println("""
\\begin{table}[htbp]
\\centering
\\begin{tabular}{l@{\\hspace{1cm}}l}
\\toprule
\\textbf{Algorithm} & \\textbf{p-value} \\\\
\\midrule""")

    for algorithm in ["gmm", "gmm_oas", "gmm_ledoitwolf"]
        df1 = filter(row -> row.algorithm == algorithm, results)
        df2 = filter(row -> row.algorithm == "gmm_shrunk", results)

        v = @sprintf "%.2E" pvalue(SignedRankTest(df1.ari, df2.ari))
        str = replace(v, "E" => "\\times 10^{") * "}"
        println("$(translation[algorithm]) & \$$str\$ \\\\")
    end

    println("""
\\bottomrule
\\end{tabular}
\\caption{TODO}
\\end{table}
""")

    println("""
\\begin{table}[htbp]
\\centering
\\begin{tabular}{l@{\\hspace{1cm}}l}
\\toprule
\\textbf{Algorithm} & \\textbf{p-value} \\\\
\\midrule""")

    for algorithm in ["kmeans", "kmeans_hg", "gmm"]
        df1 = filter(row -> row.algorithm == algorithm, results)
        df2 = filter(row -> row.algorithm == "gmm_hg_shrunk", results)

        v = @sprintf "%.2E" pvalue(SignedRankTest(df1.ari, df2.ari))
        str = replace(v, "E" => "\\times 10^{") * "}"
        println("$(translation[algorithm]) & \$$str\$ \\\\")
    end

    println("""
\\bottomrule
\\end{tabular}
\\caption{TODO}
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
        "kmeans" => "%.3f", 
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

    results = CSV.read(joinpath("results", "synthetical-v2.csv"), DataFrame)
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