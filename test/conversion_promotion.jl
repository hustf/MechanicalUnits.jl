using MechanicalUnits
using Test
@testset "Identical vs equal quantities" begin
    v1 = [1m, 1mm]
    v2 = [1000mm, 1mm]
    @test v1 == v2
    @test v1 !== v2
end
#=
import Base.show
Base.show(io::IO, ::MIME"application/prs.juno.inline", q::Quantity) = Base.show(io, "---")
1m isa Quantity
Juno.@enter show(stderr, 1m)
=#