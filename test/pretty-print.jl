using MechanicalUnits
using Test
function shortp(p)
    iob=IOBuffer()
    show(IOContext(iob, :color=>true), p)
    take!(iob)|>String
end
p = 2m
@test shortp(p) == "2\e[36mm\e[39m"
function longp(p)
    iob=IOBuffer()
    show(IOContext(iob, :color=>true), :"text/plain", p)
    take!(iob)|>String
end
@test longp(p) == "Pos{Float64}([1.0, 2.0]\e[36mm\e[39m)"
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
