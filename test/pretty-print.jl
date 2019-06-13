using MechanicalUnits
using Test
# temp1
import MechanicalUnits: abbr, unit, sortexp, tens, showrep, dimension
#import MechanicalUnits: Dimension, Dimensions
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


@testset "Modified Dimension type signatures" begin
    @test shortp(typeof(1kg∙K∙m/s)) == "Quantity{Int64,Length*Mass*Temperature*Time^-1,FreeUnits{(\e[36mkg\e[39m, \e[36mK\e[39m, \e[36mm\e[39m, \e[36ms^-1\e[39m),Length*Mass*Temperature*Time^-1,nothing}}"
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
        println("  --  ")
        println("bu = ", bu)
        println("di = ", di)
        println("res = ", res)
        println(expec1*expec2*expec3)
        @test res == expec1*expec2*expec3
    end
end

