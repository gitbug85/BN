#[no_mangle]
pub extern "C" fn rs_add(a: i32, b: i32) -> i32 {
    a + b
}

#[no_mangle]
pub extern "C" fn rs_sub(a: i32, b: i32) -> i32 {
    a - b
}

#[no_mangle]
pub extern "C" fn rs_mult(a: i32, b: i32) -> i32 {
    a * b
}

#[no_mangle]
pub extern "C" fn rs_int_div(a: i32, b: i32) -> i32 {
    a / b
}
