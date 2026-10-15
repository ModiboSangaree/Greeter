#pragma once

#include <string>

namespace greeter
{
	//Return the name of the system the program was built on:
	//"Linux", "Windows" or "Darwin" (macOS)
	//The value comes from CMake (CMAKE_SYSTEM_NAME), at configure time.
	std::string get_build_system();
	//
	std::string get_build_info();
}