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
Using units should be quick, nice and easy. That's the aim of this package, built on [Unitfu](https://github.com/hustf/Unitfu.jl), a slight modification of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl).

'Unitfu' enhances readability:
  - units are printed with colors
  - use '∙' instead of '*'
  - print common units outside of collection brackets:
  
```julia
julia> [1,2,3]m |> println
[1, 2, 3]m
julia> [1,2,3s]m |> println
[1m, 2m, 3m∙s]
´´´

'Unitfu' (and so also this package) can parse its own output:
  - drop spaces between number and measure. Printed lines can be re-used as input: `x = 1kg`
  - don't throw errors at meaningful conversions. 'Conversion factors' can be quantities, not just numbers.

```julia
julia> using MechanicalUnits

julia> 1kg∙km/s |> N
1000N∙s
```

'MechanicalUnits' defines unicode superscripts and SI prefixes when you import a unit. This is useful when you know in advance which units you are going to work with:
```julia
julia> using MechanicalUnits: @import_expand

julia> @import_expand ~ m

julia> 2km² * 1km 
2km³
```

You can also just 'use MechanicalUnits' to import all the commonly used units, prefixes and superscripts.

Benefits to using quantities rather than just numbers:
* Fewer mistakes
* More pattern recognition
* Hints to find wrong input
* Quicker problem solving
* More ways to understand a problem or read a calculation
* Functions can dispatch based on input dimensions: You would plot a force vector differently to a position vector.
* Makes quality checking of reports realistically possible.

## Units
| Units | (Derived) dimension | Dimensions |
| ------------- | ------------- | ------------- |
| nm μm μm mm cm dm m km Mm Gm Tm Pm inch ft    | Length       | 𝐋 |
| ns μs μs ms s minute d h yr                   | Time         | 𝐓 |
| mg cg kg lb shton                             | Mass         | 𝐌 |
| K Ra °C °F                                    | Temperature  | 𝚯 |
| Angles                                        | NoDims        | rad ° |
| N daN kN MN GN lbf kip                        | Force        | 𝐋∙𝐌∙𝐓⁻² |
| Pa kPa MPa GPa atm bar                        | Pressure      | 𝐌∙𝐋⁻¹∙𝐓⁻² |
| J kJ MJ GJ                                    | Energy        | 𝐋²∙𝐌∙𝐓⁻² |
| Nmm Nm daNm kNm MNm GNm                       | Moment        | 𝐋²∙𝐌∙𝐓⁻² |
| l dl cl ml                                    | Volume        | 𝐋³ |
| g                                             | Acceleration  | 𝐋∙𝐓⁻² |

## Dimensions
Dimensions are useful for defining specialized functions, e.g. `plot(F::Force)`.

| Derived dimension | Dimensions |
| ------------- | ------------- |
| Area         | 𝐋²            |
| Velocity     | 𝐋 / 𝐓         |
| Acceleration | 𝐋 / 𝐓²        |
| Force        | 𝐋∙𝐌 / 𝐓²    |
| Pressure     | 𝐌 / (𝐓²∙𝐋) |
| Density      | 𝐌 / 𝐋³        |

We avoid defining common and ambigious derived dimensions. For example, the derived dimension for Length³ = 𝐋³ could be a volume, or just as usefully a first area moment.

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
1×2 Matrix{Quantity{Float64, 𝐌∙𝐋⁻¹, FreeUnits{(kg, m⁻¹), 𝐌∙𝐋⁻¹, nothing}}}:
 30.0  42.8591

julia> l_s = 93ft*[3 4]m/s
1×2 Matrix{Quantity{Int64, 𝐋²∙𝐓⁻¹, FreeUnits{(ft, m, s⁻¹), 𝐋²∙𝐓⁻¹, nothing}}}:
 279  372

julia> m_s.*l_s .|> (kg*m)
1×2 Matrix{Quantity{Float64, 𝐋∙𝐌∙𝐓⁻¹, FreeUnits{(kg, m, s⁻¹), 𝐋∙𝐌∙𝐓⁻¹, nothing}}}:
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
1×3 Matrix{Quantity{Float64, 𝐌∙𝐓⁻², FreeUnits{(mm⁻¹, N), 𝐌∙𝐓⁻², nothing}}}:
 139.748  201.237  357.755

julia> δ(d)= F / k(d) |> mm
δ (generic function with 1 method)

julia> δ.([5, 6, 8]mm)
3-element Vector{Quantity{Float64, 𝐋, FreeUnits{(mm,), 𝐋, nothing}}}:
  7.017388381199098
  4.873186375832707
 2.7411673364058977

julia> d = 6mm
6mm

julia> dimension(d)
 𝐋

julia> 1d |> s
(3//500)m

julia> @import_expand ~V ~W ~A  G

julia> sqrt(1G²)
6.6743e-11m³∙kg⁻¹∙s⁻²

julia> [1V*12.0A 2W 1kg*g*1m/2s]*30minute .|> kJ
1×3 Matrix{Quantity{Float64, 𝐋²∙𝐌∙𝐓⁻², FreeUnits{(kJ,), 𝐋²∙𝐌∙𝐓⁻², nothing}}}:
 21.6  3.6  8.82598

julia> ω = 50*2π*rad/s
314.1592653589793rad∙s⁻¹

julia> t = (0:0.006:0.02)s
(0.0:0.006:0.018)s

julia> u = 220V*exp.(im∙(ω∙t))
4-element Vector{Quantity{ComplexF64, 𝐋²∙𝐌∙𝐈⁻¹∙𝐓⁻³, FreeUnits{(V,), 𝐋²∙𝐌∙𝐈⁻¹∙𝐓⁻³, nothing}}}:
                              220.0 + 0.0im
   -67.98373876248841 + 209.2324335849338im
 -177.98373876248843 - 129.31275550434407im
  177.98373876248843 - 129.31275550434412im

julia> u*1.5A .|> J
4-element Vector{Quantity{ComplexF64, 𝐋²∙𝐌∙𝐓⁻³, FreeUnits{(J, s⁻¹), 𝐋²∙𝐌∙𝐓⁻³, nothing}}}:
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
FreeUnits{(dyn,), 𝐋∙𝐌∙𝐓⁻², nothing}

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
* Substitute symbols which can't be displayed in Windows without installing CygWin or VSCode. .: `𝐓 -> 𝐓`
* Units show with color (although not in a text file)
* Array and tuple output moves common units outside brackets or to the header:
```julia
julia> dist = [900mm, 1.1m]
2-element Array{Quantity{Float64, 𝐋,FreeUnits{(mm,), 𝐋,nothing}},1}:
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
