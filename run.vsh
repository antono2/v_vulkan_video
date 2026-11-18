// Build and launch the development player using the compiler that runs this script.
import os

mut args := ['-d', 'debug', '-cc', 'gcc', 'run', @DIR]
player_args := os.args[1..]
args << if player_args.len > 0 && player_args[0] == '--' { player_args[1..] } else { player_args }
os.execvp(@VEXE, args) or {
	eprintln('Could not launch the development player: ${err}')
	exit(1)
}
