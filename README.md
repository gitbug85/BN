# Borrow Nim

Nim and Rust inspired language.\
Install the latest release. Put the folder where you want it. Then run ```install.sh```.
You now should be able to compile .bn files.

Example:
```
# Importing standard libraries
use math
use cli
use string
imp multiply

# Get arguments
left_operand = rs_str_to_i32(rs_arg(1))
operator = rs_arg(2)
right_operand = rs_str_to_i32(rs_arg(3))

echo operator

# Calculate and print
if rs_str_eq(operator,"+"):
    echo rs_i32_to_str(rs_add(left_operand,right_operand))
if rs_str_eq(operator,"-"):
    echo rs_i32_to_str(rs_sub(left_operand,right_operand))
if rs_str_eq(operator,"x"):
    echo rs_i32_to_str(nim_mult(left_operand,right_operand))
```
