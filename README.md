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
We're using Julia to solve difficult problems, but what about the easy ones?

Including units gives

* Fewer mistakes
* More pattern recognition
* Quicker problem solving
* An alternative approach to understanding calculations


## Usage
```julia
using MechanicalUnits
E=206GPa
A = 1mm*1mm
E*A/10100mmm
20.40N/mm
ans*100kg*g
2000mm
```

## Goals
This aims to make Julia the preferred calculator for quick side calculations. 
We accept being less general where it's massively useful. 

 Which means:
* Quantities use four significant digits with engineering formatting and unit prefixing common 
to structural and mechanical engineering.
* REPL output can be copied to make input: We print '2.32m/s' instead of '2.32 m s^-1"
* Vector output moves the units outside where possible: [1, 2]m
* We use Unicode symbols which can be shown in the Windows REPL and a nice font. 𝐓, 𝐋 and 𝐌 are replaced.
* We want to support unitful complex numbers as it helps in equation solving. It may mean switching dependencies.


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