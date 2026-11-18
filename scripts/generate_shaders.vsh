// Compile the player GLSL and emit documented V arrays.
import encoding.binary
import flag
import os
import rand

const spirv_header_bytes = 20
const spirv_word_bytes = 4
const spirv_magic = u32(0x07230203)
const words_per_line = 6
const target_environment = 'vulkan1.0'

struct Toolchain {
	glslc     string
	glslang   string
	spirv_val string
}

struct Stage {
	name    string
	source  string
	purpose string
}

const vertex = Stage{
	name:    'vertex'
	source:  'video.vert'
	purpose: 'Positions the video quad and transforms its texture coordinates.'
}

const fragment = Stage{
	name:    'fragment'
	source:  'video.frag'
	purpose: 'Samples the video texture through the YCbCr-conversion sampler.'
}

fn run_tool(executable string, args []string) ! {
	path := os.find_abs_path_of_executable(executable) or {
		return error('Shader tool unavailable: ${executable}')
	}
	if !os.is_file(path) || !os.is_executable(path) {
		return error('Shader tool unavailable: ${executable}')
	}
	mut command := os.new_process(path)
	command.set_args(args)
	command.run()
	command.wait()
	status := command.code
	command.close()
	if status != 0 {
		return error('Shader command failed (${status}): ${executable} ${args.join(' ')}')
	}
}

fn render(stage Stage, spirv []u8) !string {
	if spirv.len < spirv_header_bytes || spirv.len % spirv_word_bytes != 0 {
		return error('Invalid ${stage.name} SPIR-V length')
	}
	if binary.little_endian_u32(spirv) != spirv_magic {
		return error('Invalid ${stage.name} SPIR-V magic')
	}
	mut words := []string{cap: spirv.len / spirv_word_bytes}
	for offset := 0; offset < spirv.len; offset += spirv_word_bytes {
		words << '0x${binary.little_endian_u32(spirv[offset..]):08x}'
	}
	words[0] = 'u32(${words[0]})'
	mut lines := [
		'// ${stage.purpose}',
		'// Generated from ${stage.source}; do not edit the embedded SPIR-V words.',
		'// Regenerate: v run scripts/generate_shaders.vsh (toolchain: BUILDING.md).',
		'module main',
		'',
		'const g_${stage.name}_shader = [',
	]
	for first := 0; first < words.len; first += words_per_line {
		last := if first + words_per_line < words.len { first + words_per_line } else { words.len }
		lines << '\t' + words[first..last].join(', ') + ','
	}
	lines << ']'
	return lines.join('\n') + '\n'
}

fn compile_stage(root string, temporary string, stage Stage, tools Toolchain) !string {
	source := os.join_path(root, stage.source)
	spirv := os.join_path(temporary, stage.name + '.spv')
	if stage.name == vertex.name {
		run_tool(tools.glslc, ['--target-env=${target_environment}', source, '-o', spirv])!
	} else {
		run_tool(tools.glslang, ['-V', '--target-env', target_environment, source, '-o', spirv])!
	}
	run_tool(tools.spirv_val, ['--target-env', target_environment, spirv])!
	return render(stage, os.read_bytes(spirv)!)
}

fn generate(root string, temporary string, tools Toolchain, check bool) !bool {
	// Validate both stages before writing either output.
	outputs := [
		compile_stage(root, temporary, vertex, tools)!,
		compile_stage(root, temporary, fragment, tools)!,
	]
	mut current := true
	for index, stage in [vertex, fragment] {
		name := stage.name + '_shader.v'
		path := os.join_path(root, name)
		previous := if os.exists(path) { os.read_file(path)! } else { '' }
		if previous == outputs[index] {
			continue
		}
		if check {
			println('Stale generated shader: ${name}')
			current = false
		} else {
			os.write_file(path, outputs[index])!
			println('Generated ${name}')
		}
	}
	return current
}

fn self_test(root string, temporary string, tools Toolchain) ! {
	fixture := os.join_path(temporary, 'shader fixture')
	os.mkdir(fixture)!
	for stage in [vertex, fragment] {
		os.cp(os.join_path(root, stage.source), os.join_path(fixture, stage.source))!
	}
	assert generate(fixture, temporary, tools, false)!
	assert generate(fixture, temporary, tools, true)!
	vertex_output := os.join_path(fixture, 'vertex_shader.v')
	fragment_output := os.join_path(fixture, 'fragment_shader.v')
	vertex_expected := os.read_file(vertex_output)!
	fragment_expected := os.read_file(fragment_output)!
	assert vertex_expected.contains('Regenerate: v run scripts/generate_shaders.vsh')
	stale := 'stale output\n'
	os.write_file(fragment_output, stale)!
	assert !generate(fixture, temporary, tools, true)!
	assert os.read_file(fragment_output)! == stale
	assert os.read_file(vertex_output)! == vertex_expected
	assert generate(fixture, temporary, tools, false)!
	assert os.read_file(fragment_output)! == fragment_expected

	// Change the first output so the failure in the second stage also proves
	// that a successful first stage could not overwrite it on its own.
	os.write_file(vertex_output, stale)!
	os.write_file(os.join_path(fixture, fragment.source), 'invalid shader\n')!
	mut failed := false
	generate(fixture, temporary, tools, false) or {
		failed = true
		false
	}
	assert failed
	assert os.read_file(vertex_output)! == stale
	assert os.read_file(fragment_output)! == fragment_expected
	println('Shader regeneration, drift detection, and failed-build preservation passed.')
}

fn run_cli() !bool {
	mut parser := flag.new_flag_parser(os.args[1..])
	parser.application('generate_shaders')
	parser.description('Regenerate or check the embedded video shaders.')
	check := parser.bool('check', 0, false, 'verify generated files without writing them')
	test := parser.bool('self-test', 0, false,
		'test regeneration and refusal in a temporary directory')
	tools := Toolchain{
		glslc:     parser.string('glslc', 0, 'glslc', 'vertex shader compiler')
		glslang:   parser.string('glslang', 0, 'glslangValidator', 'fragment shader compiler')
		spirv_val: parser.string('spirv-val', 0, 'spirv-val', 'SPIR-V validator')
	}
	if parser.bool('help', `h`, false, 'show help') {
		println(parser.usage())
		return true
	}
	if parser.finalize()!.len != 0 {
		return error('unexpected positional arguments')
	}
	temporary := os.join_path(os.temp_dir(), 'video-shaders-' + rand.uuid_v4())
	os.mkdir(temporary)!
	defer { os.rmdir_all(temporary) or {} }
	root := os.dir(@DIR)
	if test {
		self_test(root, temporary, tools)!
		return true
	}
	return generate(root, temporary, tools, check)
}

current := run_cli() or {
	eprintln(err)
	exit(1)
}
if !current {
	exit(1)
}
