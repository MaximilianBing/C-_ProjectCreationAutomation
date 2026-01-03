#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit 1
else
    workingDir=$PWD
    targetDir=$1
    toBeCreatedDirs=("build-debug" "build-release" "src" "include")
    
    cmakeFile="CMakeLists.txt"
    cmakeFileHomeCommands=('cmake_minimum_required(VERSION \x20 3.10)\n\n' "project($1)\n\n" 'set(CMAKE_CXX_STANDARD \x20 17)\n' 'set(CMAKE_CXX_STANDARD_REQUIRED \x20 ON)\n' 'set(CMAKE_RUNTIME_OUTPUT_DIRECTORY\x20 ${CMAKE_BINARY_DIR}/bin)\n\n' 'include_directories(${CMAKE_SOURCE_DIR}/include)\n\n' 'add_subdirectory(${CMAKE_SOURCE_DIR}/src)')

    cmakeFileSrcCommand='add_executable(main main.cpp)'
    mainFile="main.cpp"
    mainFileCommand=$'#include <iostream>\n\nint main(int argc, char** argv) {\n\tstd::cout << "Hello World" << std::endl;\n\treturn 0;\n}\n'

    mkdir $targetDir
    cd $targetDir

    for dir in ${toBeCreatedDirs[@]}; do
        mkdir $dir
        if [ "$dir" = "src" ]; then
            cd $dir
            touch $mainFile
            printf '%s' "$mainFileCommand" > $mainFile
            touch $cmakeFile
            printf "$cmakeFileSrcCommand" >> $cmakeFile
            cd ..
        fi
    done

    touch $cmakeFile

    for cmd in ${cmakeFileHomeCommands[@]}; do
        printf "$cmd" >> $cmakeFile
    done 
fi