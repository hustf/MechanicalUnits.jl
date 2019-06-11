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
        usy = Symbol(bu*di)
        println(typeof(eval(usy)))
    end
end




# TODO: Test superscripts, dimensions.


#= 
Currently dead code

[Ra, K, h, μm, minute]
for q1 in testunits, q2 in testunits
    q1 == q2 && continue
    print("q1, q2, res = ", q1, " , ", q2, " , ")
    show(stderr,  :"text/plain", longp(2q1∙3q2))
    println()
    println("@test shortp(2q1 * 3q2) == res")
  #println(2*q1*3*q2)
end
testunits = 
m², m³, m⁴, s², s³, s⁴, g², kg³, kg⁴
°C, °F
Ra, Ra², Ra³, Ra⁴, K, K², K³, K⁴
h, μm, minute
h², μm², minute²
h³, μm³, minute³
h⁴, μm⁴, minute⁴
di in ["²", "³", "⁴"], 
for bu in ["m", "s", "kg", "Ra", "K", "h", "μm", "minute"]
   # usy = Symbol(di*bu)
    print(bu, " => \"Mass\", ")
end
show(stderr, :"text/plain", longp(1kg∙K∙m/s))
=#