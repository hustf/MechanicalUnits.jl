"""
    exponents_superscripts(x:Symbol)
    -> expressions to define and export constants
       xⁿ = x^n  where n  ∈ [-4:-1, 2:4]

The number of dimensions and units is limited enough that we
can define the exponents for all units.
"""
function exponents_superscripts(sy::Symbol)
    ex2 = Symbol(sy, "²")
    ex3 = Symbol(sy, "³")
    ex4 = Symbol(sy, "⁴")
    exm1 = Symbol(sy, "⁻¹")
    exm2 = Symbol(sy, "⁻²")
    exm3 = Symbol(sy, "⁻³")
    exm4 = Symbol(sy, "⁻⁴")
    quote
        const global $ex2 = $sy^2
        const global $ex3 = $sy^3
        const global $ex4 = $sy^4
        const global $exm1 = $sy^-1
        const global $exm2 = $sy^-2
        const global $exm3 = $sy^-3
        const global $exm4 = $sy^-4
        export $ex2, $ex3, $ex4, $exm1,  $exm2, $exm3, $exm4
    end
end

# The below macros and functions are based on https://github.com/JuliaAstro/UnitfulAstro.jl/blob/master/src/UnitfulAstro.jl

"""
Import non-affine units from Unitfu.
Expand to also include 'fancy' exponents -4 to 4, i.e. m² etc.
"""
macro import_expand(args...)
    expr = Expr(:block)
    for arg in args
        use_SI_prefixes, sym = should_we_use_SI_prefixes(arg)
        if use_SI_prefixes
            # We have defined a smaller subset of SI prefixes commonly used in this domain.
            for prefix in mechanical_si_prefixes
                sym′ = Symbol(prefix, sym)
                # Some prefix+baseunit are excluded:
                if sym′ ∉ exclude_import
                    push!(expr.args, :(import MechanicalUnits.Unitfu.$sym′))
                    # AstroUnits don't reexport, but we do:
                    push!(expr.args, :(export $sym′))
                    push!(MECH_UNITS, sym′)
                    push!(expr.args, exponents_superscripts(sym′))
                end
            end
        else
            push!(expr.args, :(import MechanicalUnits.Unitfu.$sym))
            # AstroUnits don't reexport, but we do:
            push!(expr.args, :(export $sym))
            push!(MECH_UNITS, sym)
            push!(expr.args, exponents_superscripts(sym))
        end
    end
    esc(expr)
end
"Import affine units from Unitfu."
macro import_affine_from_Unitfu(args...)
    expr = Expr(:block)
    for arg in args
        push!(expr.args, :(import MechanicalUnits.Unitfu.$arg))
        # AstroUnits don't reexport, but we do:
        push!(expr.args, :(export $arg))
        push!(MECH_UNITS, arg)
    end
    esc(expr)
end

function should_we_use_SI_prefixes(arg::Expr)
    if arg.head == :(call)
        if arg.args[1] == :(~)
            return true, arg.args[2]
        else
            error("incorrect first argument $arg")
        end
    else
        error("incorrect expression head: $arg")
    end
end
should_we_use_SI_prefixes(arg::Symbol) = false, arg
