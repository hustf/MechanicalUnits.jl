# MechanicalUnits

[![Build Status](https://ci.appveyor.com/api/projects/status/github/hustf/MechanicalUnits.jl?svg=true)](https://ci.appveyor.com/project/hustf/MechanicalUnits-jl)
[![Coveralls](https://coveralls.io/repos/github/hustf/MechanicalUnits.jl/badge.svg?branch=master)](https://coveralls.io/github/hustf/MechanicalUnits.jl?branch=master)

  - [Units](#units)
  - [Dimensions](#dimensions)
  - [Usage](#usage)
  - [Goals](#goals)
  - [Alternatives](#alternatives)
  - [FAQ](#faq)
  - [Contributing](#contributing)
  - [License](#license)


### Convenient units in the REPL
Using units should be quick, nice and easy. That's the aim of this package, built on a slight [modification](https://github.com/hustf/Unitfu.jl).of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl).

We enhance readability with colors, and we don't throw errors at meaningful input:

```julia
julia> 1kg∙m∙s⁻¹ |> N
1N∙s
```

Benefits to using quantities rather than just numbers:
* Fewer mistakes
* More pattern recognition
* Hints to find wrong input
* Quicker problem solving
* More ways to understand a problem or read a calculation
* Functions can dispatch based on input dimensions: You would plot a force vector differently to a position.

## Units
| Units | (Derived) dimension | Dimensions |
| ------------- | ------------- | ------------- |
| nm μm μm mm cm dm m km Mm Gm Tm Pm inch ft    | Length       | ᴸ |
| ns μs μs ms s minute d h yr                   | Time         | ᵀ |
| mg cg kg lb shton                             | Mass         | ᴹ |
| K Ra °C °F                                    | Temperature  | ᶿ |
| Angles                                        | NoDims        | rad ° |
| N daN kN MN GN lbf kip                        | Force        | ᴸ∙ ᴹ ∙ ᵀ⁻² |
| Pa kPa MPa GPa atm bar                        | Pressure      | ᴹ ∙ ᴸ⁻¹ ∙ ᵀ⁻² |
| J kJ MJ GJ                                    | Energy        | ᴸ² ∙ ᴹ ∙ ᵀ⁻² |
| Nmm Nm daNm kNm MNm GNm                       | Moment        | ᴸ² ∙ ᴹ ∙ ᵀ⁻² |
| l dl cl ml                                    | Volume        | ᴸ³ |
| g                                             | Acceleration  | ᴸ ∙ ᵀ⁻² |

## Dimensions
Dimensions are useful for defining specialized functions, e.g. `plot(F::Force)`.

| Derived dimension | Dimensions |
| ------------- | ------------- |
| Area         | ᴸ²            |
| Velocity     | ᴸ / ᵀ         |
| Acceleration | ᴸ / ᵀ²        |
| Force        | ᴸ ∙ ᴹ / ᵀ²    |
| Pressure     | ᴹ / (ᵀ² ∙ ᴸ ) |
| Density      | ᴹ / ᴸ³        |

We avoid defining common and ambigious derived dimensions. For example, the derived dimension for Length³ = ᴸ³ could be a volume, or just as usefully a first area moment.

## Usage

### Installation
We appreciate 'Unitful.jl', but do need some specific syntax. To avoid conflict, Unitfu.jl and this package is registered in a separate registry, which holds related packages for solving, plotting, sketching and latex with units.

```julia
pkg> registry add https://github.com/hustf/M8
pkg> registry add MechanicalUnits
```


### Example REPL workflow

Let us do some quick side calculations (code in `/example`):

```julia
julia> using MechanicalUnits

julia> m_air = 1000kg; c_p = 1.00kJ/(kg*K)
1.0kJ∙kg⁻¹∙K⁻¹
julia> @import_expand ~W   # Watt = Joule / Second is not exported by default. Several: (u1, u2,..)

julia> Q_cp(T1, T2) = m_air * c_p * (T2 - T1) |> (kW*h)
Q_cp (generic function with 1 method)

julia> Q_cp(20°C, 985°C)
268.05555555555554kW∙h

julia> dm |> upreferred
mm

julia> preferunits(m) # No effect, since upreferred was called once this session

julia> m_s = [30kg/m 28.8lb/ft]
1×2 Matrix{Quantity{Float64,  ᴹ∙ ᴸ⁻¹, FreeUnits{(kg, m⁻¹),  ᴹ∙ ᴸ⁻¹, nothing}}}:
 30.0  42.8591

julia> l_s = 93ft*[3 4]m/s
1×2 Matrix{Quantity{Int64,  ᴸ²∙ ᵀ⁻¹, FreeUnits{(ft, m, s⁻¹),  ᴸ²∙ ᵀ⁻¹, nothing}}}:
 279  372

julia> m_s.*l_s .|> (kg*m)
1×2 Matrix{Quantity{Float64,  ᴸ∙ ᴹ∙ ᵀ⁻¹, FreeUnits{(kg, m, s⁻¹),  ᴸ∙ ᴹ∙ ᵀ⁻¹, nothing}}}:
 2551.18  4859.61

julia> E=206GPa; h_y = 100mm; b = 30mm; I = 1/12 * b * h_y^3
2.5e6mm⁴

julia> L = 2m; F=100kg*g |> N
980.665N

julia> F*L^3/(3E*I) |> upreferred
5.0778770226537215mm

julia> l_wire = 20m
20m

julia> k(d) = E * 0.691 * π/4 * d^2 / l_wire |> N/mm
k (generic function with 1 method)

julia> k.([5 6 8]mm)
1×3 Matrix{Quantity{Float64,  ᴹ∙ ᵀ⁻², FreeUnits{(mm⁻¹, N),  ᴹ∙ ᵀ⁻², nothing}}}:
 139.748  201.237  357.755

julia> δ(d)= F / k(d) |> mm
δ (generic function with 1 method)

julia> δ.([5, 6, 8]mm)
3-element Vector{Quantity{Float64,  ᴸ, FreeUnits{(mm,),  ᴸ, nothing}}}:
  7.017388381199098
  4.873186375832707
 2.7411673364058977

julia> d = 6mm
6mm

julia> dimension(d)
 ᴸ

julia> 1d |> s
(3//500)m

julia> @import_expand ~V ~W ~A  G

julia> sqrt(1G²)
6.6743e-11m³∙kg⁻¹∙s⁻²

julia> [1V*12.0A 2W 1kg*g*1m/2s]*30minute .|> kJ
1×3 Matrix{Quantity{Float64,  ᴸ²∙ ᴹ∙ ᵀ⁻², FreeUnits{(kJ,),  ᴸ²∙ ᴹ∙ ᵀ⁻², nothing}}}:
 21.6  3.6  8.82598

julia> ω = 50*2π*rad/s
314.1592653589793rad∙s⁻¹

julia> t = (0:0.006:0.02)s
(0.0:0.006:0.018)s

julia> u = 220V*exp.(im∙(ω∙t))
4-element Vector{Quantity{ComplexF64,  ᴸ²∙ ᴹ∙ ᴵ⁻¹∙ ᵀ⁻³, FreeUnits{(V,),  ᴸ²∙ ᴹ∙ ᴵ⁻¹∙ ᵀ⁻³, nothing}}}:
                              220.0 + 0.0im
   -67.98373876248841 + 209.2324335849338im
 -177.98373876248843 - 129.31275550434407im
  177.98373876248843 - 129.31275550434412im

julia> u*1.5A .|> J
4-element Vector{Quantity{ComplexF64,  ᴸ²∙ ᴹ∙ ᵀ⁻³, FreeUnits{(J, s⁻¹),  ᴸ²∙ ᴹ∙ ᵀ⁻³, nothing}}}:
                             330.0 + 0.0im
 -101.97560814373261 + 313.8486503774007im
 -266.97560814373264 - 193.9691332565161im
  266.97560814373264 - 193.9691332565162im
```

### Importing fewer units, or other units
If you want fewer globally defined variables, @import_expand just what you need:

```julia
julia> import MechanicalUnits: @import_expand, ∙

julia> @import_expand ~m dyn     # ~ : also import SI prefixes for metre

julia> (1.0cm², 2.0mm∙m, 3.0dm⁴/m² ) .|> mm²
(100.0, 2000.0, 300.0)mm²

julia> typeof(dyn)
FreeUnits{(dyn,),  ᴸ∙ ᴹ∙ ᵀ⁻², nothing}

julia> 1dyn |> μm
10kg∙μm∙s⁻²
```

### Parsing text
When parsing a text file, typically from some other software, spaces as multipliers and brackets are allowed. Tabs are also accepted. But you need to specify the numeric type of output quantities, like this:

```julia
julia> strinp = "2 [s]\t11364.56982421875 [N]\t-44553.50244140625 [N]\t-26.586366176605225 [N]\t0.0[N mm]\t0.0[N mm]\t0.0[N mm]\t1561.00350618362 [mm]\t-6072.3729133606 [mm]\t2825.15907287598 [mm]";

julia> time, Fx, Fy, Fz, Mx, My, Mz, px, py, pz = parse.(Quantity{Float64}, split(strinp, '\t'))
10-element Vector{Quantity{Float64, D, U} where {D, U}}:
                 2.0s
   11364.56982421875N
  -44553.50244140625N
 -26.586366176605225N
    0.0mm∙N
    0.0mm∙N
    0.0mm∙N
   1561.00350618362mm
   -6072.3729133606mm
   2825.15907287598mm
```


### Special case: Units without dimension
Unit conversion works slightly different with such units, because the dimension is undefined. Here are some workarounds (using `ustrip` is discouraged since calculation errors may be masked by such operations):

```julia
julia> strain = 10.6μm/m
10.6μm∙m⁻¹

julia> strain |> upreferred
1.0599999999999998e-5

julia> strain *m/μm
10.6

julia> strain |> NoUnits
1.0599999999999998e-5
```


## Goals
This dependency of a [fork](https://github.com/hustf/Unitfu.jl) of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) aims to be a tool for quick side calculations in an office computer.

This means:
* We pick a set of units as commonly used in mechanical industry
* `h` is an hour, not Planck's constant
* `in` is reserved by Julia; `inch` is a unit
* `g` is gravity's acceleration, not a gramme
* Prefer `mm` and `MPa`
* Non-decorated REPL output can always be parsed as input. We define the bullet operator `∙` (U+2219, \vysmblkcircle + tab) and print e.g. `2.32m∙s⁻¹`
* Substitute symbols which can't be displayed in Windows without installing CygWin or VSCode. .: `𝐓 -> ᵀ`
* Units show with color (although not in a text file)
* Array and tuple output moves common units outside brackets or to the header:
```julia
julia> dist = [900mm, 1.1m]
2-element Array{Quantity{Float64, ᴸ,FreeUnits{(mm,), ᴸ,nothing}},1}:
  900.0
 1100.0
```
We would like to:
* not rely on a tweaked fork of Unitful, but the original
* register the package and have full test coverage

## Alternatives
See [Unitful.jl](https://github.com/PainterQubits/Unitful.jl)


## Am I missing some essential feature?

- Open an [issue](https://github.com/hustf/MechanicalUnits/issues/new) and let's make this better together!

- *Bug reports, feature requests, patches, and well-wishes are always welcome.*

## Contributing

It's the usual github way: fork, develop locally, push a commit to your fork, make a pull request.
For traceability and discussions, please make an [issue](https://github.com/hustf/MechanicalUnits/issues/new) and refer to the pull request.


## License

MechanicalUnits is released under the [MIT License](http://www.opensource.org/licenses/MIT).