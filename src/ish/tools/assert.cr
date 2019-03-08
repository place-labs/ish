# Macros for argument validation.
module Ish::Assert
  macro bounded(name, lower, upper)
    if {{name}} <= {{lower}} || {{name}} >= {{upper}}
      raise "{{name}} must be between {{lower}} and {{upper}}, exclusive"
    end
  end

  macro greater_than(name, x)
    raise "{{name}} must be greater than {{x}}" unless {{name}} > {{x}}
  end
end
