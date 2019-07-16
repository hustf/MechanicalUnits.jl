using MechanicalUnits
using Test
@testset "Identical vs equal quantities" begin
    v1 = [1m, 1mm]
    v2 = [1000mm, 1mm]
    @test v1 == v2
    @test v1 !== v2
end

@testset "Conversion factors" begin
    @test convfact(m, cm) == 1//100
    @test convfact(kg*m, cm) == (1//100)kg
end

@testset "Flexible conversions" begin
    @test cm(1m) === (100//1)cm
    @test cm(1.0m) === 100.0cm
    @test cm(1kg*m) == (100//1)cm∙kg⁻¹
    # Actual error: The numeric type needs to be fixed.
    @test N*mm(1.0kNm) === 1.0e6*N*mm
    @test cm(1.0kg*m) === 100.0cm
end
