using MechanicalUnits
using Test
@info "Starting test"
@testset "MechanicalUnits.jl" begin
    @testset "pretty-print.jl"  begin
        include("pretty-print.jl")
    end
    @testset "conversion_promotion.jl"  begin
        include("conversion_promotion.jl")
    end
    @testset "prefixes.jl"  begin
        include("prefixes.jl")
    end
end
