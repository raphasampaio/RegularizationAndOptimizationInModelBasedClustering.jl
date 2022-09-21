function parse_commandline(args)
    s = ArgParseSettings()
    
    @add_arg_table! s begin
        "-k"
            default = [3, 10, 20]
            arg_type = Vector{Int}
            eval_arg = true
            help = ""
        "-c"
            default = [-0.26, -0.1, 0.01, 0.21]
            arg_type = Vector{Float64}
            eval_arg = true
            help = ""
        "-d"
            default = [2, 5, 10, 20, 30, 40]
            arg_type = Vector{Int}
            eval_arg = true
            help = ""
        "-i"
            default = [1:20;]
            arg_type = Vector{Int}
            eval_arg = true
            help = ""
        "--uci"
            action = :store_true
            help = ""
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
