using MechanicalUnits
using Test
shortp(x) = repr(x, context = :color=>true)
longp(x) = repr(:"text/plain", x, context = :color=>true)

@testset "Most basic" begin
    testunits = [m ,  s ,  kg ]
    for u in testunits
        st = "2\e[36m$u\e[39m"
        @test shortp(2u) == st
        @test longp(2u) == st
    end
    # Products of most basic quantities
    q1, q2, res = m , s , "6\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(q1 * q2) == longp(q1 * q2)
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = m , kg , "6\e[36mkg\e[39m∙\e[36mm\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = s , m , "6\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = s , kg , "6\e[36mkg\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = kg , m , "6\e[36mkg\e[39m∙\e[36mm\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = kg , s , "6\e[36mkg\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
end

@testset "Special temperature units, Affine units" begin
    testunits = [°C, °F]
    for u in testunits
        st = "3\e[36m$u\e[39m"
        @test shortp(3u) == st
        @test longp(3u) == st
    end
    # These quantities can't be multiplied, so that's it.
end


@testset "Fahrenheit intervals, Kelvin, directly derived units" begin
    testunits = [Ra, K, h, μm, minute]
    for u in testunits
        st = "2\e[36m$u\e[39m"
        @test shortp(2u) == st
        @test longp(2u) == st
    end
    q1, q2, res = m , s , "6\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = m , kg , "6\e[36mkg\e[39m∙\e[36mm\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = s , m , "6\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = s , kg , "6\e[36mkg\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = kg , m , "6\e[36mkg\e[39m∙\e[36mm\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = kg , s , "6\e[36mkg\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
end


@testset "Constructors from type signatures" begin
    buf =IOBuffer()
    print(IOContext(buf, :showconstructor => true), 1m)
    @test String(take!(buf)) == "1Unit{:Meter,Length}(0, 1//1)"
    print(buf, 1m)
    @test String(take!(buf)) == "1m"
    @test shortp(typeof(1kg∙K∙m/s)) == "Quantity{Int64,Length*Mass*Temperature*Time^-1,FreeUnits{(Unit{:Gram,Mass}" *
                                    "(3, 1//1), Unit{:Kelvin,Temperature}(0, 1//1), " *
                                    "Unit{:Meter,Length}(0, 1//1), Unit{:Second,Time}(0, -1//1))," *
                                    "Length*Mass*Temperature*Time^-1,nothing}}"
    q1 = Quantity{Int64, Length, FreeUnits{(Unit{:Meter, Length}(0,1),), Length, nothing}}(2)
    q2 = 2m
    @test q1 == q2
    @test q1 === q2
    strcon = repr(:"text/plain", typeof(q2), context = :color=>false)
    tq1 = typeof(q1)
    @test strcon == "Quantity{Int64,Length,FreeUnits{(Unit{:Meter,Length}(0, 1//1),),Length,nothing}}"
    sy = Meta.parse(strcon)
    ex = :($sy(2))
    q3 = eval(ex)
    @test q1 == q3
    @test q1 === q3
end

@testset "Type signatures, dimensions 1 to 4" begin
    dimdi = Dict([m => "Length", s => "Time", kg => "Mass", 
            Ra => "Temperature", K => "Temperature", h => "Time", 
            μm => "Length", minute => "Time"])
    expdidi = Dict(["²" => "^2", "³" => "^3", "⁴" => "^4"])
    for bu in ["m", "s", "kg", "Ra", "K", "h", "μm", "minute"], di in ["²", "³", "⁴"]
        res = shortp(typeof(eval(Symbol(bu*di))))
        expec1 = "FreeUnits{(\e[36m" * bu * di* "\e[39m,),"
        expec2 = dimdi[eval(Meta.parse(bu)) ]
        expec3 =  expdidi[di] * ",nothing}"
        @test res == expec1*expec2*expec3
    end
end

