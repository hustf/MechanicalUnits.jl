using MechanicalUnits
using Test

@testset "MechanicalUnits.jl" begin
    @testset "pretty-print.jl"  begin
        include("pretty-print.jl")
    end
    @testset "conversion_promotion.jl"  begin
        include("conversion_promotion.jl")
    end
end
