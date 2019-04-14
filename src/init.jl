##### Beginning of file

function __init__()::Nothing
    global delayed_error_list = Vector{DelayedError}()
    # atexit(() -> process_delayed_error_list(delayed_error_list))
    _print_welcome_message()
    return nothing
end

##### End of file
