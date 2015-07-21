Makefile [![Build Status](http://bit.ly/1Mh3MO8)](http://bit.ly/1DrgAdK)
========

This project is a generic/dynamic Makefile compatible with OS X and Linux for
use in C/C++ applications.  This Makefile has various built-in commands
available for use:

* `make all` - Builds the project using default settings
* `make clean` - Cleans all objects and residue from compilation
* `make debug` - Builds the project using the same flags as `make all` in
addition to providing the DEBUG=1 macro to all objects
* `make test` - Builds the project using default settings (unless already built
with `make debug`) and runs `cppcheck` and `valgrind` to aid in the development
process
* `make zip` - Builds a ZIP file of all source code and the Makefile

Requirements
============

This project depends on several packages in order to be fully functional:

* `build-essential` - This provides a compiler and the `make` command
* `cppcheck` - Used in `make test` to provide suggestions for your code
* `valgrind` - Used to test your program for memory leaks using `make test`
* `zip` - Used to make the ZIP file with `make zip`

Usage
=====

To use this project, hard-link to the Makefile in your project root.  Example:

```bash
ln /path/to/Makefile ./Makefile
```

Note:  a hard-link is used so that git does not track the Makefile in your
project as a symlink.  Hard-links are detected as regular files by git.

Configuration
=============

Makefile has various configuration facilities available:

## `.Makefile-libs`

The `.Makefile-libs` config is a file that should contain a string of libraries
to compile against.  Example:  `-ldl -levent2 -letc`

## `.Makefile-modsdir`

The `.Makefile-mods` config is a file that should contain a relative path to a
directory that should be recursively compiled as shared objects for dynamic
linking at runtime.  Example:  `modules`

## `.Makefile-out`

The `.Makefile-out` config is a file that holds the desired name of the
resulting binary after successful compilation.  Example:  `main` or `a.out`
