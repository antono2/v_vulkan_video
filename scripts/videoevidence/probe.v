// Capture diagnostics from a subprocess without leaving it running after a timeout.
module videoevidence

import os
import strings
import time

pub fn probe(command []string, timeout time.Duration) os.Result {
	if command.len == 0 {
		return os.Result{
			exit_code: -1
			output:    'missing command'
		}
	}
	executable := os.find_abs_path_of_executable(command[0]) or {
		return os.Result{
			exit_code: -1
			output:    '${command[0]} was not found'
		}
	}
	mut process := os.new_process(executable)
	process.set_args(command[1..])
	process.set_redirect_stdio()
	process.run()
	defer {
		if process.is_alive() {
			process.signal_kill()
		}
		process.wait()
		process.close()
	}
	if process.status != .running {
		return os.Result{
			exit_code: -1
			output:    process.err
		}
	}
	clock := time.new_stopwatch()
	mut output := strings.new_builder(4096)
	mut errors := strings.new_builder(1024)
	for {
		alive := process.is_alive()
		out := process.stdout_read()
		err := process.stderr_read()
		output.write_string(out)
		errors.write_string(err)
		if !alive && out == '' && err == '' {
			break
		}
		if clock.elapsed() >= timeout {
			return os.Result{
				exit_code: -1
				output:    '${command[0]} exceeded ${timeout}'
			}
		}
		if out == '' && err == '' {
			time.sleep(poll_interval)
		}
	}
	process.wait()
	return os.Result{
		exit_code: process.code
		output:    (output.str() + errors.str()).trim_space()
	}
}
