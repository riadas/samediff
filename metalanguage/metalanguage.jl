include("../base/base_semantics.jl")

all_specs = []

for perceptual_similarity_bound in [0, 1, 2]
    for same_defined in [false, true]
        for different_defined in [false, true]
            push!(all_specs, (perceptual_similarity_bound, same_defined, different_defined))
        end
    end
end

manually_defined = Dict([
    (0, false, false) => "chance",
    (1, false, false) => "MTS",
    (2, false, false) => "samediff",
    (2, true, false) => "same_RMTS",
    (2, true, true) => "full_RMTS"
])

manual_specs = filter(x -> x in keys(manually_defined), all_specs)