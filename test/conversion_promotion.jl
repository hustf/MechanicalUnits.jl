using MechanicalUnits
using Test
@testset "Identical vs equal quantities" begin
    m(1e6μm) == 1.0m
    1e6μm == 1.0m
    !(1e6μm === 1m)
    m(1e6μm) === 1.0m
    1e6μm |> m === 1.0m
    1000μm * 1m |> m² === 1//1000m^2
    1.0m² == 1.0m^2
    1.0m² === 1.0m^2
    (1//1000)m²
end