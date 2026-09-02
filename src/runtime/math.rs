use std::ffi::CStr;
use std::os::raw::c_char;

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

#[no_mangle]
pub extern "C" fn rs_str_to_i32(s: *const c_char) -> i32 {
    if s.is_null() {
        return 0;
    }

    let s = unsafe { CStr::from_ptr(s) };

    match s.to_str().ok().and_then(|s| s.parse::<i32>().ok()) {
        Some(value) => value,
        None => 0,
    }
}
