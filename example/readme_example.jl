# Run line by line in the REPL, or ctrl + enter in VSCode
# First code section
using MechanicalUnits
m_air = 1000kg; c_p = 1.00kJ/(kg*K)
@import_expand ~W   # Watt = Joule / Second is not exported by default. Several: (u1, u2,..)
Q_cp(T1, T2) = m_air * c_p * (T2 - T1) |> (kW*h)
Q_cp(20°C, 985°C)
dm |> upreferred
preferunits(m) # No effect, since upreferred was called once this session
m_s = [30kg/m 28.8lb/ft]
l_s = 93ft*[3 4]m/s
m_s.*l_s .|> (kg*m)
E=206GPa; h_y = 100mm; b = 30mm; I = 1/12 * b * h_y^3
L = 2m; F=100kg*g |> N
F*L^3/(3E*I) |> upreferred
l_wire = 20m
k(d) = E * 0.691 * π/4 * d^2 / l_wire |> N/mm
k.([5 6 8]mm)
δ(d)= F / k(d) |> mm
δ.([5, 6, 8]mm)
d = 6mm
dimension(d)
1d |> s
@import_expand ~V ~W ~A  G
sqrt(1G²)
[1V*12.0A 2W 1kg*g*1m/2s]*30minute .|> kJ
ω = 50*2π*rad/s
t = (0:0.006:0.02)s
u = 220V*exp.(im∙(ω∙t))
u*1.5A .|> J

# Second code section
import MechanicalUnits: @import_expand, ∙
@import_expand ~m dyn     # ~ : also import SI prefixes for metre
(1.0cm², 2.0mm∙m, 3.0dm⁴/m² ) .|> mm²
typeof(dyn)
1dyn |> μm



# Third code section
strinp = "2 [s]\t11364.56982421875 [N]\t-44553.50244140625 [N]\t-26.586366176605225 [N]\t0.0[N mm]\t0.0[N mm]\t0.0[N mm]\t1561.00350618362 [mm]\t-6072.3729133606 [mm]\t2825.15907287598 [mm]";

time, Fx, Fy, Fz, Mx, My, Mz, px, py, pz = parse.(Quantity{Float64}, split(strinp, '\t'))

# Fourth code section
strain = 10.6μm/m
strain |> upreferred
strain *m/μm
strain |> NoUnits