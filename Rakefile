# frozen_string_literal: true

require_relative 'scaffold/scaffold'

PROJECT_NAME = 'hello_world'
case RUBY_PLATFORM
when /mswin|mingw|cygwin/
  GENERATOR = Scaffold::CMake::Generator::VS_16
when /darwin|linux/
  GENERATOR = Scaffold::CMake::Generator::NINJA
end

namespace :build do
  task :debug do
    Scaffold::CMake.gen(project: PROJECT_NAME, generator: GENERATOR, config: 'Debug')
    Scaffold::CMake.build(config: 'Debug')
  end

  task :release do
    Scaffold::CMake.gen(project: PROJECT_NAME, generator: GENERATOR, config: 'Release')
    Scaffold::CMake.build(config: 'Release')
  end
end

task :clean do
  Scaffold::CMake.clean
end

task default: 'build:debug'
