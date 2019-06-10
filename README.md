# MechanicalUnits

[![Build Status](https://ci.appveyor.com/api/projects/status/github/hustf/MechanicalUnits.jl?svg=true)](https://ci.appveyor.com/project/hustf/MechanicalUnits-jl)
[![Coveralls](https://coveralls.io/repos/github/hustf/MechanicalUnits.jl/badge.svg?branch=master)](https://coveralls.io/github/hustf/MechanicalUnits.jl?branch=master)


  - [Usage](#usage)
  - [Goals](#goals)
  - [Alternatives](#alternatives)
    - [Projects using this library](#projects using this library)
  - [FAQ](#faq)
  - [Contributing](#contributing)
  - [License](#license)


### Using units helps you
A calculator just eats up the difficulties in pre-algebra. You'll get the divisions and fractions right every time. When using pure SI units, engineering problems can still be solved that way. But you soon loose track of what every number 'means'. 

Using units gives

* Fewer mistakes
* More pattern recognition
* Hints to find wrong input
* Quicker problem solving
* More ways to understand a physical problem or read a calculation


## Usage
```julia
using MechanicalUnits
# which car to use?
70l / 42MJ/kg / 0.745kg/l / 0.8l/10km

75kWh/12.2kWh/100km

# Which wire rope diameter to pick?
E=206GPa
A = 1mm*1mm*0.741
E*A/10100mmm
20.40N/mm
ans*100kg*g
2000mm
```
Base.delete_method(@which foo(0.2))
Or even better, put 'using MechanicalUnits' in the .julia/config/startup.jl

The exported units can be listed:
```varinfo(MechanicalUnits)```

You may get warning messages when also loading other packages. If that happens, switch to importing
just what you need
```import MechanicalUnits: N, kg, m, s, MPa```


## Goals
This adaption of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) aims to make Julia a preferable tool for quick side calculations. We accept being less general when that is useful for the mechanical or structural engineer, working in a Windows environment.

This means:
* `h` is an hour, not Planck's constant
* `in` is still a function, `inch` is a unit
* REPL output can be copied to input: `2.32 m s^-1` is printed as `2.32m/s`
* Prefer length prefixes `μ` and `mm`
* Prefer force and moment prefix `k`
* Prefer stress prefix `M`
* Prefer `Pa`over `N/m²`
* Define the bullet operator `∙` (U+2219, \vysmblkcircle + tab in Julia). This is simply to avoid less recognizable units like `N*m` while also being able to use printed results as input.
* Thousands separator is supported, but limited to an acceptable format for Julia input: ```983_322Nm```
* Four significant digits output, but don't round when it would display zeros: 983_322N
* Array output moves the units outside where possible: [0.0009, 239_912]mm, not [0.900mm, 239.9 m]
* Substitute symbols which can't be displayed in Windows terminals: 𝐓 -> Time, 𝐋 -> Length, 𝐌 -> Mass
* We would like to support unitful complex numbers, as they often appear while solving equations. 
* Energy and moment units are both important in the contexts, but using `J` conveys meaning. We would like to provide a special REPL mode for picking an output preference while typing, for examply by typing `ctrl + .` and then correcting a suggested output. 
* The `ctrl + .` REPL mode would resemble typing on the right-hand side of an equation. It gives no meaning after function definitions. Any defined parameter could be treated as a unit. 


## Alternatives

[Unitful.jl](https://github.com/PainterQubits/Unitful.jl) lists similar adaptions for other fields.


### Projects using this library

None.

## Am I missing some essential feature?

- **Nothing is impossible!**

- Open an [issue](https://github.com/hustf/MechanicalUnits/issues/new) and let's make this better together!

- *Bug reports, feature requests, patches, and well-wishes are always welcome.* :heavy_exclamation_mark:

## FAQ

- ***Is this for real?***

Yes. Unlike complex numbers. This is not so far for complex numbers.

*What does this cost?*

It costs nothing if your time is free.

## Contributing

It's the usual github way: fork, develop locally, push a commit to your fork, make a pull request.
For traceability and discussions, please make an [issue](https://github.com/hustf/MechanicalUnits/issues/new) and refer to the pull request.


## License

MechanicalUnits is released under the [MIT License](http://www.opensource.org/licenses/MIT).