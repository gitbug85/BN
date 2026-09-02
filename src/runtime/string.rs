use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::ptr;

#[no_mangle]
pub extern "C" fn rs_str_len(s: *const c_char) -> usize {
    if s.is_null() {
        return 0;
    }

    unsafe { CStr::from_ptr(s).to_bytes().len() }
}

#[no_mangle]
pub extern "C" fn rs_str_eq(a: *const c_char, b: *const c_char) -> bool {
    if a.is_null() || b.is_null() {
        return a == b;
    }

    unsafe { CStr::from_ptr(a) == CStr::from_ptr(b) }
}

#[no_mangle]
pub extern "C" fn rs_str_dup(s: *const c_char) -> *mut c_char {
    if s.is_null() {
        return ptr::null_mut();
    }

    let s = unsafe { CStr::from_ptr(s) };

    match CString::new(s.to_bytes()) {
        Ok(value) => value.into_raw(),
        Err(_) => ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn rs_str_free(s: *mut c_char) {
    if s.is_null() {
        return;
    }

    unsafe {
        drop(CString::from_raw(s));
    }
}

#[no_mangle]
pub extern "C" fn rs_str_concat(a: *const c_char, b: *const c_char) -> *mut c_char {
    if a.is_null() || b.is_null() {
        return ptr::null_mut();
    }

    let a = unsafe { CStr::from_ptr(a) };
    let b = unsafe { CStr::from_ptr(b) };

    let mut result = Vec::with_capacity(a.to_bytes().len() + b.to_bytes().len() + 1);
    result.extend_from_slice(a.to_bytes());
    result.extend_from_slice(b.to_bytes());

    match CString::new(result) {
        Ok(value) => value.into_raw(),
        Err(_) => ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn rs_i32_to_str(value: i32) -> *mut c_char {
    match CString::new(value.to_string()) {
        Ok(s) => s.into_raw(),
        Err(_) => ptr::null_mut(),
    }
}
