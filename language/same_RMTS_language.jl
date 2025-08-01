include("../base/base_semantics.jl")

function same(x::Doubleton)
    x.obj1 == x.obj2
end

function different(x::Doubleton)
    true
end

same_diff_defined = Dict([
    "same" => true, 
    "different" => false,
])

function evaluate(task::Task)
    if task isa RMTS
        println("WHOA")
        println(Base.invokelatest(same, task.query))
    end
    if task.query isa Singleton || task isa SameDifferent || task isa RMTS && Base.invokelatest(same, task.query)
        1.0
    else
        0.5
    end
end