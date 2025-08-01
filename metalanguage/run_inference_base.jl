include("metalanguage.jl")
include("../task_configs/generate_tasks.jl")
using Plots 

specs = manual_specs

max_repeats = 10
alpha_perceptual_similarity_bound = 0.04
alpha_same_defined = 0.05
alpha_different_defined = 0.02

function compute_prior(spec)
    perceptual_similarity_bound, same_defined, different_defined = spec 

    alpha_perceptual_similarity_bound^(perceptual_similarity_bound) * (same_defined ? alpha_same_defined : (1 - alpha_same_defined)) * (different_defined ? alpha_different_defined : (1 - alpha_different_defined))
end

function compute_likelihood(spec, tasks)
    manual_spec_name = manually_defined[spec]
    include("../language/$(manual_spec_name)_language.jl")
    probs = []
    for task in tasks
        prob = Base.invokelatest(evaluate, task)
        push!(probs, prob)
    end
    foldl(*, probs, init=1.0)
end

priors = Dict()
likelihoods = Dict()
results = Dict()
for spec in specs
    println(manually_defined[spec])
    results[spec] = []
    prior = compute_prior(spec)
    likelihood = compute_likelihood(spec, tasks)

    priors[spec] = prior 
    likelihoods[spec] = likelihood

    for repeats in 1:max_repeats
        push!(results[spec], prior*(likelihood)^(repeats))
    end
end

for spec in specs 
    println("spec_name: $(manually_defined[spec])")
    println("----- prior: $(priors[spec])")
    println("----- likelihood: $(likelihoods[spec])")
end

for i in 1:max_repeats 
    println("repeats: $(i)")
    for spec in specs 
        println("----- spec_name: $(manually_defined[spec]), posterior: $(results[spec][i])")
    end
end

sums = map(r -> sum(map(spec -> results[spec][r], specs)), 1:max_repeats)

pretty_spec_names = Dict([
    "chance" => "chance (no tasks solved)",
    "MTS" => "singleton perceptual similarity, i.e. 'A' vs. 'B' (MTS solved)",
    "samediff" => "doubleton perceptual similarity, i.e. 'AA' vs. 'AB' (same-different task solved)",
    "same_RMTS" => "same understanding (same-only RMTS task solved)",
    "full_RMTS" => "same/different understanding (full RMTS task solved)",
])

# plot
p = plot(1:max_repeats, collect(1:max_repeats) * 1/max_repeats, color="white", label=false, xticks=0:1:max_repeats, size=(800,600), dpi=600)
for spec in specs
    spec_name = manually_defined[spec] 
    println(spec_name)
    p = plot!(collect(1:max_repeats), results[spec] ./ sums, label = "$(pretty_spec_names[spec_name])", legend=:outerbottom, xticks=0:1:max_repeats, size=(800,600), dpi=600)
end

xlabel!("Training Data Volume", xguidefontsize=9)
ylabel!("Proportion", yguidefontsize=9)
title!("Relative Proportions of Relational Similarity LoTs", titlefontsize=10)

p