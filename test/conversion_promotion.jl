using MechanicalUnits
using Test
@testset "Identical vs equal quantities" begin
    v1 = [1m, 1mm]
    v2 = [1000mm, 1mm]
    @test v1 == v2
    @test v1 !== v2
end

@testset "Conversion factors and conversions with identical dimensions" begin
    @test convfact(m, cm) == 1//100
    @test convfact(kg*m, kg*cm) == (1//100)
    @test cm(1m) === (100//1)cm
    @test cm(1.0m) === 100.0cm
    @test cm(2m) === (200//1)cm
    @test cm(2.0m) === 200.0cm
    @test mm(1.0m) == 1.0e3*mm
    @test (N*mm)(1.0N*m) == (1000/1)N*mm
    @test kNm(1.0e6N*mm) == 1.0e6N*mm
    @test kNm(1.0e6N*mm) !== 1.0e6N*mm
    @test kNm(1.0e6N*mm) === kNm(1.0e6N*mm)
end

@testset "Flexible conversions" begin
    @test convfact(m, kg) === (1//1000)kg∙mm⁻¹
    @test cm(1kg*m) === (100//1)kg∙cm
    @test cm(1kg*m) == 1kg*m
    @test cm(1kg*m) !== 1kg*m
    @test cm(1kg*m) === (100//1)kg∙cm
    @test mm(2.0kg*m) == 2.0kg*m
    @test mm(2.0kg*m) !== 2.0kg*m
    @test mm(2.0kg*m) === 2000.0kg∙mm
    @test (kg*m)(1ft*lb) ≈ 1ft*lb
    @test (kg*m)(1ft*lb) === 0.13825495437600002kg∙m
    @test 0.13825495437600002kg∙m + 1ft∙lb ≈ 2ft∙lb
    @test 0.13825495437600002kg∙m + 1ft∙lb === 276.509908752kg∙mm
end

@testset "Conversions with arrays" begin
    v = [1N 2daN]
    @test v |> kg == [1000//1  20000//1]kg∙mm∙s⁻²
    @test (v |> kg .=== Array([(1000//1) (20000//1)]kg*mm*s^-2)) == [true true]
end