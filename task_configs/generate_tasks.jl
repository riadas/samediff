include("../base/base_semantics.jl")

MTS_task = MTS(Obs("A"), (Obs("A"), Obs("B")), 1)
SameDifferent_task_same = SameDifferent(Obs("XX"), 
 ([Obs("AA"), Obs("BB"), Obs("CC"), Obs("DD")], 
  [Obs("AB"), Obs("BC"), Obs("CD"), Obs("DA")]),
 1)
SameDifferent_task_diff = SameDifferent(Obs("XY"), 
 ([Obs("AA"), Obs("BB"), Obs("CC"), Obs("DD")], 
  [Obs("AB"), Obs("BC"), Obs("CD"), Obs("DA")]),
 1)
RMTS_task_same = RMTS(Obs("AA"), (Obs("BB"), Obs("CD")), 1)
RMTS_task_diff = RMTS(Obs("AB"), (Obs("BB"), Obs("CD")), 1)

MTS_tasks = [
    MTS_task,
    MTS_task,
    MTS_task,
    MTS_task,
]

SameDifferent_tasks = [
    SameDifferent_task_same, # same query
    SameDifferent_task_diff # different query
]

RMTS_tasks = [
    RMTS_task_same, # same query (only query type in same-only RMTS)
    RMTS_task_diff # different query
]

tasks = [
    MTS_tasks...,
    SameDifferent_tasks...,
    RMTS_tasks...
]