# Borrow Nim

Nim and Rust inspired language.\
Install Nim and rustc to use this. Then run ```build.sh```.
You now should be able to compile .bn files.

This is what it can currently do.
```
# Importing standard libraries
use math
use cli
use string

# Get arguments
left_operand = rs_str_to_i32(rs_arg(1))
operator = rs_arg(2)
right_operand = rs_str_to_i32(rs_arg(3))

# Set operators
plus = "+"
minus = "-"

# Calculate and print
if rs_str_eq(operator,plus):
    echo rs_i32_to_str(rs_add(left_operand,right_operand))
if rs_str_eq(operator,minus):
    echo rs_i32_to_str(rs_sub(left_operand,right_operand))

```
