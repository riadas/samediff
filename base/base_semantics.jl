import Base

abstract type Task end
abstract type Obs end

struct Object 
    name::String
end

struct Singleton <: Obs 
    obj::Object
end

struct Doubleton <: Obs 
    obj1::Object
    obj2::Object
end

struct MTS <: Task 
    query::Obs
    categories::Tuple{<:Obs, <:Obs}
    answer::Integer
    symbolic_label::Bool
end

struct RMTS <: Task 
    query::Obs
    categories::Tuple{<:Obs, <:Obs}
    answer::Integer
    symbolic_label::Bool
end

struct SameDifferent <: Task 
    query::Obs
    categories::Tuple{Vector{<:Obs}, Vector{<:Obs}}
    answer::Integer
    symbolic_label::Bool
end

MTS(query::Obs, categories::Tuple{<:Obs, <:Obs}, answer::Integer) = MTS(query, categories, answer, false)
SameDifferent(query::Obs, categories::Tuple{Vector{<:Obs}, Vector{<:Obs}}, answer::Integer) = SameDifferent(query, categories, answer, false)
RMTS(query::Obs, categories::Tuple{<:Obs, <:Obs}, answer::Integer) = RMTS(query, categories, answer, false)

Singleton(s::String) = Singleton(Object(s))
Doubleton(s::String) = Doubleton(Object(s[1:1]), Object(s[2:2]))
Obs(s::String) = length(s) == 1 ? Singleton(s) : Doubleton(s)

Base.string(x::Singleton) = "$(x.obj.name)"
Base.string(x::Doubleton) = "$(x.obj1.name)$(x.obj2.name)"
Base.string(x::Vector{<:Obs}) = """[$(join(map(a -> string(a), x), ", "))]"""
Base.string(x::MTS) = "MTS($(x.query), ($(x.categories[1]), $(x.categories[2])), $(x.answer), $(x.symbolic_label))"
Base.string(x::SameDifferent) = """SameDifferent($(x.query), ([$(join(map(a -> string(a), x.categories[1]), ", "))], [$(join(map(a -> string(a), x.categories[2]), ", "))]), $(x.answer), $(x.symbolic_label))"""
Base.string(x::RMTS) = "RMTS($(x.query), ($(x.categories[1]), $(x.categories[2])), $(x.answer), $(x.symbolic_label))"

Base.show(io::IO, x::Obs) = show(io, Base.string(x))