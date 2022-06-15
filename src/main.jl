function main(args)
    @info("RegularizationAndGlobalOptimizationInModelBasedClustering - version: $_VERSION")

    # parsed_args = parse_commandline(args)

    initialize()

    reset_timer!()
    run()
    print_timer(sortby = :name)

    return nothing
end

function julia_main()::Cint
    main(ARGS)
    return 0
end
