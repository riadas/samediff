include("../base/base_semantics.jl")

function same(x::Doubleton)
    true
end

function different(x::Doubleton)
    true
end

same_diff_defined = Dict([
    "same" => false, 
    "different" => false,
])

function evaluate(task::Task)
    if task.query isa Singleton 
        1.0
    else
        0.5
    end
end