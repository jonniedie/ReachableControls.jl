using ReachableControls
using Documenter

DocMeta.setdocmeta!(ReachableControls, :DocTestSetup, :(using ReachableControls); recursive=true)

makedocs(;
    modules=[ReachableControls],
    authors="Jonnie Diegelman <jonniediegelman@gmail.com> and contributors",
    repo="https://github.com/jonniedie/ReachableControls.jl/blob/{commit}{path}#{line}",
    sitename="ReachableControls.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jonniedie.github.io/ReachableControls.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jonniedie/ReachableControls.jl",
    devbranch="main",
)
