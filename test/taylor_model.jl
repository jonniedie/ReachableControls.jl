
# From https://github.com/JuliaIntervals/TaylorModels.jl/issues/127
@testset "Taylor model" begin
    using ReachableControls.TaylorModels

    n(z, a) = a * z
    d(z, a) = 1 + a * z
    G(z, a) = n(z, a) / d(z, a)

    dom_a = 0.5 ± 0.125 # domain for a
    dom_ω = 1 ± (1 / 16)  # domain for ω

    set_variables("δa δω", order = 6)
    aN = TaylorModelN(1, 3, Interval(mid(dom_a)) × Interval(mid(dom_ω)), dom_a × dom_ω)
    ωN = TaylorModelN(2, 3, Interval(mid(dom_a)) × Interval(mid(dom_ω)), dom_a × dom_ω)

    gNr, gNi = G(as_real(ωN)*im, as_real(aN))

    gNi(IntervalBox(dom_a - mid(dom_a), dom_ω - mid(dom_ω)))
end