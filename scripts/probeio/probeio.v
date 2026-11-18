// Run bounded subprocess probes without a shell.
module probeio

import os
import strings
import time

const probe_interval = 10 * time.millisecond

pub struct ProbeResult {
pub:
	ok     bool
	detail string
}

pub fn find_executable(name string) string {
	if os.is_abs_path(name) && os.is_file(name) && os.is_executable(name) {
		return name
	}
	path := os.find_abs_path_of_executable(name) or { return '' }
	return if os.is_file(path) && os.is_executable(path) { path } else { '' }
}

pub fn run_probe(executable string, args []string, timeout time.Duration) ProbeResult {
	path := find_executable(executable)
	if path == '' {
		return ProbeResult{
			detail: 'Executable unavailable: ${executable}'
		}
	}
	mut child := os.new_process(path)
	child.set_args(args)
	child.set_redirect_stdio()
	child.run()
	defer { child.close() }
	mut stdout := strings.new_builder(256)
	mut stderr := strings.new_builder(256)
	timer := time.new_stopwatch()
	for {
		live := child.is_alive()
		out := child.stdout_read()
		err := child.stderr_read()
		stdout.write_string(out)
		stderr.write_string(err)
		if !live && out == '' && err == '' {
			child.wait()
			break
		}
		if timer.elapsed() >= timeout {
			if live {
				child.signal_kill()
				// wait() reaps a killed POSIX child only from a running status.
				child.status = .running
				child.wait()
			}
			return ProbeResult{
				detail: 'Timed out after ${timeout}: ${executable}'
			}
		}
		if out == '' && err == '' {
			time.sleep(probe_interval)
		}
	}
	detail := (stdout.str() + stderr.str()).replace('\r\n', '\n').trim_space()
	return ProbeResult{
		ok:     child.code == 0
		detail: if detail == '' { child.err } else { detail }
	}
}
