include("../base/base_semantics.jl")

function same(x::Doubleton)
    x.obj1 == x.obj2
end

function different(x::Doubleton)
    x.obj1 != x.obj2 # different tends to be harder to learn than same
end

same_diff_defined = Dict([
    "same" => true, 
    "different" => true,
])

function evaluate(task::Task)
    1.0
end

# TODO: fact that not/all immediately operate correctly once same/different are learned (i.e. all same / all different / etc.)
# TODO: actual algorithms