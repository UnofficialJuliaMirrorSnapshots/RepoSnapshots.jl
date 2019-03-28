##### Beginning of file

module Types # Begin submodule Snapshots.Types

__precompile__(true)

abstract type AbstractInterval end

function _name_with_jl(x::AbstractString)::String
    name_without_jl::String = _name_without_jl(x)
    name_with_jl::String = string(name_without_jl, ".jl")
    return name_with_jl
end

function _name_without_jl(x::AbstractString)::String
    temp::String = strip(convert(String, x))
    if endswith(lowercase(temp), ".jl")
        result = strip(temp[1:end-3])
    else
        result = temp
    end
    return result
end

function _name_with_git(x::AbstractString)::String
    name_without_git::String = _name_without_git(x)
    name_with_git::String = string(name_without_git, ".git")
    return name_with_git
end

function _name_without_git(x::AbstractString)::String
    temp::String = strip(convert(String, x))
    if endswith(lowercase(temp), ".git")
        result = strip(temp[1:end-4])
    else
        result = temp
    end
    return result
end

function _is_interval(x::String)::Bool
    if _is_no_bounds_interval(x)
        return true
    elseif _is_lower_bound_only_interval(x)
        return true
    elseif _is_upper_bound_only_interval(x)
        return true
    elseif _is_lower_and_upper_bound_interval(x)
        return true
    else
        return false
    end
end

function _get_lower_and_upper_bound_interval_regex()::Regex
    lower_and_upper_bound_interval_regex::Regex =
        r"\[(\w\w*?)\,(\w\w*?)\)"
    return lower_and_upper_bound_interval_regex
end

function _get_lower_bound_only_interval_regex()::Regex
    lower_bound_only_interval_regex::Regex =
        r"\[(\w\w*?)\,\)"
    return lower_bound_only_interval_regex
end

function _get_upper_bound_only_interval_regex()::Regex
    upper_bound_only_interval_regex::Regex =
        r"\[\,(\w\w*?)\)"
    return upper_bound_only_interval_regex
end

function _get_no_bounds_interval_regex()::Regex
    no_bounds_interval_regex::Regex =
        r"\[\,\)"
    return no_bounds_interval_regex
end

function _is_no_bounds_interval(x::String)::Bool
    result::Bool = occursin(
        _get_no_bounds_interval_regex(),
        x,
        )
    return result
end

function _is_lower_and_upper_bound_interval(x::String)::Bool
    result::Bool = occursin(
        _get_lower_and_upper_bound_interval_regex(),
        x,
        )
    return result
end

function _is_lower_bound_only_interval(x::String)::Bool
    result::Bool = occursin(
        _get_lower_bound_only_interval_regex(),
        x,
        )
    return result
end

function _is_upper_bound_only_interval(x::String)::Bool
    result::Bool = occursin(
        _get_upper_bound_only_interval_regex(),
        x,
        )
    return result
end

struct NoBoundsInterval <: AbstractInterval
end

struct LowerAndUpperBoundInterval <: AbstractInterval
    left::String
    right::String
    function LowerAndUpperBoundInterval(
            left::String,
            right::String,
            )::LowerAndUpperBoundInterval
        correct_left = strip(left)
        correct_right = strip(right)
        result::LowerAndUpperBoundInterval = new(
            correct_left,
            correct_right,
            )
        return result
    end
end

struct LowerBoundOnlyInterval <: AbstractInterval
    left::String
    function LowerBoundOnlyInterval(
            left::String,
            )::LowerBoundOnlyInterval
        correct_left = strip(left)
        result::LowerBoundOnlyInterval = new(
            correct_left,
            )
        return result
    end
end

struct UpperBoundOnlyInterval <: AbstractInterval
    right::String
    function UpperBoundOnlyInterval(
            right::String,
            )::UpperBoundOnlyInterval
        correct_right = strip(right)
        result::UpperBoundOnlyInterval = new(
            correct_right,
            )
        return result
    end
end

function _construct_interval(x::String)::AbstractInterval
    if _is_no_bounds_interval(x)
        result = NoBoundsInterval()
    elseif _is_lower_bound_only_interval(x)
        loweronly_regexmatch::RegexMatch = match(
            _get_lower_bound_only_interval_regex(),
            x,
            )
        loweronly_left::String = strip(
            convert(String, loweronly_regexmatch[1])
            )
        result = LowerBoundOnlyInterval(loweronly_left)
    elseif _is_upper_bound_only_interval(x)
        upperonly_regexmatch::RegexMatch = match(
            _get_upper_bound_only_interval_regex(),
            x,
            )
        upperonly_right::String = strip(
            convert(String, upperonly_regexmatch[1])
            )
        result = UpperBoundOnlyInterval(upperonly_right)
    elseif _is_lower_and_upper_bound_interval(x)
        lowerandupper_regexmatch::RegexMatch = match(
            _get_lower_and_upper_bound_interval_regex(),
            x,
            )
        lowerandupper_left::String = strip(
            convert(String, lowerandupper_regexmatch[1])
            )
        lowerandupper_right::String = strip(
            convert(String, lowerandupper_regexmatch[2])
            )
        result = LowerAndUpperBoundInterval(
            lowerandupper_left,
            lowerandupper_right,
            )
    else
        error("argument is not a valid interval")
    end
    return result
end

end # End submodule Snapshots.Types

##### End of file
