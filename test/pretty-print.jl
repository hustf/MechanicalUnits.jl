using MechanicalUnits
using Test
# temp
#import MechanicalUnits: abbr, unit, sortexp, tens, showrep, dimension
#import MechanicalUnits: Dimension, Dimensions
shortp(x) = repr(x, context = :color=>true)
longp(x) = repr(:"text/plain", x, context = :color=>true)
#    iob=IOBuffer()
#    show(IOContext(iob, :color=>true), :"text/plain", p)
#    take!(iob)|>String
#end
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
    @test shortp(typeof(1kg∙K∙m/s)) == "Unitful.Quantity{Int64,Length*Mass*Temperature*Time^-1,Unitful.FreeUnits{(\e[36mkg\e[39m, \e[36mK\e[39m, \e[36mm\e[39m, \e[36ms^-1\e[39m),Length*Mass*Temperature*Time^-1,nothing}}"
end


# TODO: Test superscripts, dimensions.


#= 

Currently dead code
vp = [p, p]
@test shortp(vp) == "[[1.0, 2.0], [1.0, 2.0]]\e[36mm\e[39m"
@test longp(vp) == "2-element Npos{Pos{Float64}}:\n[[1.0, 2.0], [1.0, 2.0]]\e[36mm\e[39m"
p1 = [1,1]m
p2 = [2,2]m
p3 = [3,3]m
p4 = [4,4]m
mp = hcat([p1, p2], [p3, p4])
@test mp[2,1] == p2
@test shortp(mp) == "[[1.0, 1.0] [3.0, 3.0]; [2.0, 2.0] [4.0, 4.0]]\e[36mm\e[39m"
@test longp(mp) == "2x2 Npos{Pos{Float64}}:\n[[1.0, 1.0] [3.0, 3.0]; [2.0, 2.0] [4.0, 4.0]]\e[36mm\e[39m"




[Ra, K, h, μm, minute]
for q1 in testunits, q2 in testunits
    q1 == q2 && continue
    print("q1, q2, res = ", q1, " , ", q2, " , ")
    show(stderr,  :"text/plain", longp(2q1∙3q2))
    println()
    println("@test shortp(2q1 * 3q2) == res")
  #println(2*q1*3*q2)
end

show(stderr, :"text/plain", longp(1kg∙K∙m/s))
=#