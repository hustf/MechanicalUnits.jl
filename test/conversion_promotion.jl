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
    @test cm(1m) === 100cm
    @test cm(1.0m) === 100.0cm
    @test cm(2m) === 200cm
    @test cm(2.0m) === 200.0cm
    @test mm(1.0m) == 1.0e3*mm
    @test (N*mm)(1.0N*m) == (1000/1)N*mm
    @test kNm(1.0e6N*mm) == 1.0e6N*mm
    @test kNm(1.0e6N*mm) !== 1.0e6N*mm
    @test kNm(1.0e6N*mm) === kNm(1.0e6N*mm)
end

@testset "Flexible conversions" begin
    @test convfact(m, kg) === (1//1000)kg∙mm⁻¹
    @test cm(1kg*m) === 100kg∙cm
    @test cm(1kg*m) == 1kg*m
    @test cm(1kg*m) !== 1kg*m
    @test cm(1kg*m) === 100kg∙cm
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

@testset "Mixed collections" begin
    @test [1m 1m^2/mm] == [1000 1000000]mm
    @test [1m 1m^2/mm] == [1 1000]m
    @test (1m, 1m^2/mm) == (1000, 1000000)mm
    @test (1m, 1m^2/mm) == (1, 1000)m
end

@testset "Quantity parse" begin
    @test parse(Quantity{Float64}, "2.0kN") == 2.0kN
    @test  parse(Quantity{Int64}, "2 kN") == 2kN
    @test  parse(Quantity{Int64}, "2 [m]") == 2m
    @test  parse(Quantity{Float64}, "2 [m]") == 2.0m
    @test  parse(Quantity{Float64}, "2 [N m]") == 2.0Nm
    lin = "2 [s]\t11364.56982421875 [N]\t-44553.50244140625 [N]\t-26.586366176605225 [N]\t0.0[N mm]\t0.0[N mm]\t0.0[N mm]\t1561.00350618362 [mm]\t-6072.3729133606 [mm]\t2825.15907287598 [mm]"
    data = parse.(Quantity{Float64}, split(lin, '\t'))
    @test  data ==  [ 2.0s, 11364.56982421875N, -44553.50244140625N, -26.586366176605225N,  0.0mm∙N, 0.0mm∙N, 0.0mm∙N, 1561.00350618362mm, -6072.3729133606mm, 2825.15907287598mm]
    @test parse(Quantity{Float64}, "2.3E05m") == 230000m
end
