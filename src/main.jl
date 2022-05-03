# function finish_path(path::String)
#     if isempty(path)
#         return path
#     end
#     if isfile(path)
#         return normpath(path)
#     end
#     if Sys.islinux() && path[end] != '/'
#         return normpath(path * "/")
#     elseif Sys.iswindows() && path[end] != '\\'
#         return normpath(path * "\\")
#     else
#         return normpath(path)
#     end
# end
# function parse_commandline(args)
#     s = ArgParse.ArgParseSettings()

#     ArgParse.@add_arg_table! s begin
#         "--opt1"
#         help = "an option with an argument"
#         action = :store_true
#         "path"
#         help = "path to the case inputs"
#         arg_type = String
#         default = pwd()
#     end
#     # dump args into dict
#     parsed_args = ArgParse.parse_args(args, s)

#     # Possibly fix paths and apply the normpath method
#     parsed_args["path"] = finish_path(parsed_args["path"])
#     if !isdir(parsed_args["path"])
#         error("The directory " * parsed_args["path"] * " does not exist.") 
#     end

#     return parsed_args
# end

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
