using MechanicalUnits
using Test

@testset "MechanicalUnits.jl" begin
    @testset "Pretty-print"  begin
        include("pretty-print.jl")
    end
end
