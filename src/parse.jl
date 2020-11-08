parse(::Type{Quantity{T}}, s::AbstractString; kwargs...) where {T <: Real} =
    convert(Quantity{T}, tryparse_internal(Quantity{T}, s, firstindex(s), lastindex(s), 10, true; kwargs...))

function tryparse_internal(::Type{Quantity{T}}, sbuff::Union{String,SubString{String}},
    startpos::Int, endpos::Int, base::Integer, raise::Bool) where {T<:Real}
    if isempty(sbuff)
        raise && throw(ArgumentError("input string is empty"))
        return nothing
    end

    orig_start = startpos
    orig_end   = endpos

    # Ignore leading and trailing whitespace
    while isspace(sbuff[startpos]) && startpos <= endpos
        startpos = nextind(sbuff, startpos)
    end
    while isspace(sbuff[endpos]) && endpos >= startpos
        endpos = prevind(sbuff, endpos)
    end

    # Find first character of unit specification
    unitpos = startpos
    while sbuff[unitpos] ∈ "Ee+-0123456789.," && unitpos <= endpos 
        unitpos = nextind(sbuff, unitpos)
    end

    numlen = unitpos - startpos + 1
    unitlen = endpos - unitpos + 1

    if numlen > 0 && unitlen > 0
        num = parse(T, sbuff[startpos:unitpos - 1])
        suni = strip(sbuff[unitpos:endpos], ['[', ']', ' '])
        if '/' ∉ suni
            suni = replace(suni, r"[∙· *]" => '∙')
            sunits = split(suni, '∙')
            uni =  lookup_units(MechanicalUnits, Symbol(sunits[1]))
            for string_unit in sunits[2:lastindex(sunits)]
                uni *= lookup_units(MechanicalUnits, Symbol(string_unit))
            end
            return num * uni
        end
    end

    if raise
        substr = SubString(sbuff, orig_start, orig_end) # show input string in the error to avoid confusion
        if all(isspace, substr)
            throw(ArgumentError("input string only contains whitespace"))
        elseif '/' ∉ sbuff[unitpos:endpos]
            throw(ArgumentError("input string contains '/' unit. Replace input with multiplied units: 'm/s' =>  'm∙s⁻¹'"))
        else
            throw(ArgumentError("invalid quantity representation: $(repr(substr))"))
        end
    end
    return nothing
end
