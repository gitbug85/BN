use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::path::Path;
use std::ptr;

#[no_mangle]
pub extern "C" fn rs_arg_count() -> usize {
    std::env::args_os().count()
}

#[no_mangle]
pub extern "C" fn rs_arg(index: usize) -> *mut c_char {
    match std::env::args_os().nth(index) {
        Some(arg) => {
            let arg = arg.to_string_lossy();

            match CString::new(arg.as_bytes()) {
                Ok(s) => s.into_raw(),
                Err(_) => ptr::null_mut(),
            }
        }
        None => ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn rs_path_exists(path: *const c_char) -> bool {
    if path.is_null() {
        return false;
    }

    let path = unsafe { CStr::from_ptr(path) };

    let Ok(path) = path.to_str() else {
        return false;
    };

    Path::new(path).exists()
}

#[no_mangle]
pub extern "C" fn rs_path_is_file(path: *const c_char) -> bool {
    if path.is_null() {
        return false;
    }

    let path = unsafe { CStr::from_ptr(path) };

    let Ok(path) = path.to_str() else {
        return false;
    };

    Path::new(path).is_file()
}

#[no_mangle]
pub extern "C" fn rs_path_is_dir(path: *const c_char) -> bool {
    if path.is_null() {
        return false;
    }

    let path = unsafe { CStr::from_ptr(path) };

    let Ok(path) = path.to_str() else {
        return false;
    };

    Path::new(path).is_dir()
}

#[no_mangle]
pub extern "C" fn rs_path_join(a: *const c_char, b: *const c_char) -> *mut c_char {
    if a.is_null() || b.is_null() {
        return ptr::null_mut();
    }

    let a = unsafe { CStr::from_ptr(a) };
    let b = unsafe { CStr::from_ptr(b) };

    let Ok(a) = a.to_str() else {
        return ptr::null_mut();
    };

    let Ok(b) = b.to_str() else {
        return ptr::null_mut();
    };

    let path = Path::new(a).join(b);

    match path.to_str() {
        Some(path) => match CString::new(path) {
            Ok(s) => s.into_raw(),
            Err(_) => ptr::null_mut(),
        },

        None => ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn rs_path_parent(path: *const c_char) -> *mut c_char {
    if path.is_null() {
        return ptr::null_mut();
    }

    let path = unsafe { CStr::from_ptr(path) };

    let Ok(path) = path.to_str() else {
        return ptr::null_mut();
    };

    let Some(parent) = Path::new(path).parent() else {
        return ptr::null_mut();
    };

    match parent.to_str() {
        Some(parent) => match CString::new(parent) {
            Ok(s) => s.into_raw(),
            Err(_) => ptr::null_mut(),
        },

        None => ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn rs_path_filename(path: *const c_char) -> *mut c_char {
    if path.is_null() {
        return ptr::null_mut();
    }

    let path = unsafe { CStr::from_ptr(path) };

    let Ok(path) = path.to_str() else {
        return ptr::null_mut();
    };

    let Some(filename) = Path::new(path).file_name() else {
        return ptr::null_mut();
    };

    match filename.to_str() {
        Some(filename) => match CString::new(filename) {
            Ok(s) => s.into_raw(),
            Err(_) => ptr::null_mut(),
        },

        None => ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn rs_path_extension(path: *const c_char) -> *mut c_char {
    if path.is_null() {
        return ptr::null_mut();
    }

    let path = unsafe { CStr::from_ptr(path) };

    let Ok(path) = path.to_str() else {
        return ptr::null_mut();
    };

    let Some(extension) = Path::new(path).extension() else {
        return ptr::null_mut();
    };

    match extension.to_str() {
        Some(extension) => match CString::new(extension) {
            Ok(s) => s.into_raw(),
            Err(_) => ptr::null_mut(),
        },

        None => ptr::null_mut(),
    }
}
