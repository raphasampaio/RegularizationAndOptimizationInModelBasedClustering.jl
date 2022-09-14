function wilcoxon()
    translation = Dict(
        "kmeans" => "k-means",
        "kmeans_ms" => "k-means MS",
        "kmeans_rs" => "k-means RS",
        "kmeans_hg" => "k-means HG",
        "gmm" => "GMM",
        "gmm_ms" => "GMM MS",
        "gmm_rs" => "GMM RS",
        "gmm_hg" => "GMM HG",
        "gmm_shrunk" => "GMM Shrunk",
        "gmm_ms_shrunk" => "GMM MS Shrunk",
        "gmm_rs_shrunk" => "GMM RS Shrunk",
        "gmm_hg_shrunk" => "GMM HG Shrunk",
        "gmm_oas" => "GMM OAS",
        "gmm_ms_oas" => "GMM MS OAS",
        "gmm_rs_oas" => "GMM RS OAS",
        "gmm_hg_oas" => "GMM HG OAS",
        "gmm_ledoitwolf" => "GMM Ledoitwolf",
        "gmm_ms_ledoitwolf" => "GMM MS Ledoitwolf",
        "gmm_rs_ledoitwolf" => "GMM RS Ledoitwolf",
        "gmm_hg_ledoitwolf" => "GMM HG Ledoitwolf",
    )

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