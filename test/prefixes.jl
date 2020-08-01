using MechanicalUnits

using Test
@testset "Prefixes and conversions" begin
    @test 10dm == 1m
    @test 1daN == 10N
    @test m(1e6μm) == 1.0m
    @test 1e6μm == 1.0m
    @test !(1e6μm === 1m)
    @test m(1e6μm) === 1.0m
    @test 1e6μm |> m === 1.0m
    @test 1000μm * 1m |> m² === (1//1000)m^2
    @test 1.0m² == 1.0m^2
    @test 1.0m² === 1.0m^2
end
