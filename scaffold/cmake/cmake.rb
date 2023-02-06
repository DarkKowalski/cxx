# frozen_string_literal: true

require 'open3'
require 'erb'
require 'fileutils'

module Scaffold
  module CMake
    module Generator
      VS_17 = 'Visual Studio 17 2022'
      VS_16 = 'Visual Studio 16 2019'
      NINJA = 'Ninja'
      MAKE = 'Unix Makefiles'
    end

    def self.available_generators
      [Generator::VS_17, Generator::VS_16, Generator::NINJA, Generator::MAKE]
    end

    def self.version
      `#{cmake} --version`.split[2].split('-')[0].split('.')[0..1].join('.')
    end

    def self.gen(project: 'hello_world', generator: nil, config: 'Debug')
      raise "Unknown generator: #{generator}" unless available_generators.include?(generator)

      gen_top_level_cmake(project)
      gen_src_cmake(project)

      stdout, stderr, status = Open3.capture3(cmake, '-B', build_dir, '-G', generator, "-DCMAKE_BUILD_TYPE=#{config}")
      return if status.success?

      warn stderr
      puts stdout
      raise "Failed to generate project files for #{project} with #{generator}"
    end

    def self.build(config: 'Debug')
      raise "Build directory does not exist: #{build_dir}" unless Dir.exist?(build_dir)

      stdout, stderr, status = Open3.capture3(cmake, '--build', build_dir, '--config', config)
      return if status.success?

      warn stderr
      puts stdout
      raise "Failed to build project: #{status}"
    end

    def self.clean
      FileUtils.rm_rf(build_dir)
    end

    def self.gen_top_level_cmake(project)
      template = File.read(File.join(File.dirname(__FILE__), 'templates', 'CMakeLists.txt.top.erb'))
      File.write('CMakeLists.txt', ERB.new(template).result(binding))
    end

    def self.gen_src_cmake(executable)
      template = File.read(File.join(File.dirname(__FILE__), 'templates', 'CMakeLists.txt.src.erb'))
      File.write(File.join('src', 'CMakeLists.txt'), ERB.new(template).result(binding))
    end

    def self.source_files
      Dir.glob('src/*').reject { |f| f.end_with?('CMakeLists.txt') }.map { |f| File.basename(f) }.join("\n")
    end

    def self.languages
      ext_list = Dir.glob('src/*').map { |f| File.extname(f) }.uniq
      result = []
      result << 'C' if ext_list.include?('.c')
      result << 'CXX' if ext_list.include?('.cpp') || ext_list.include?('.cc')
      case RUBY_PLATFORM
      when /mswin|mingw|cygwin/
        result << 'ASM_MASM' if ext_list.include?('.asm')
      when /darwin|linux/
        result << 'ASM' if ext_list.include?('.asm') || ext_list.include?('.s') || ext_list.include?('.S')
      end
      result.join(' ')
    end

    def self.build_dir
      'build'
    end

    def self.cxx_standard
      17
    end

    def self.cmake
      'cmake'
    end
  end
end
