function parse_commandline(args)
    s = ArgParseSettings()
    
    @add_arg_table! s begin
        "-k"
            default = [3, 10, 20]
            arg_type = Vector{Int}
            eval_arg = true
        "-c"
            default = [-0.26, -0.1, 0.01, 0.21]
            arg_type = Vector{Float64}
            eval_arg = true
        "-d"
            default = [2, 5, 10, 20, 30, 40]
            arg_type = Vector{Int}
            eval_arg = true
        "-i"
            default = [1:20;]
            arg_type = Vector{Int}
            eval_arg = true
        "--uci"
            action = :store_true
        "--algorithms"
            default = [1:20;]
            arg_type = Vector{Int}
            eval_arg = true
        "--datasets"
            default = [1:21;]
            arg_type = Vector{Int}
            eval_arg = true
        "--tolerance"
            default = 1e-3
            arg_type = Float64
        "--maxiterations"
            default = 1000
            arg_type = Int
        "--verbose"
            action = :store_true
    end

    return ArgParse.parse_args(args, s)
end

function main(args)
    @info("RegularizationAndGlobalOptimizationInModelBasedClustering")

    @show options = parse_commandline(args)

    initialize()

    reset_timer!()
    run(options)
    print_timer(sortby = :name)

    return nothing
end

function julia_main()::Cint
    main(ARGS)
    return 0
end
