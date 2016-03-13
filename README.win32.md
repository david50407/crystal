Crystal version: `0.13.0`

# TODO for compiler

## Preludes

- [ ] intrinsics
- [ ] reflect
- [ ] libc
  - [ ] Time
  - [ ] Mode
- [x] macros
- [x] object
- [x] reference
- [ ] exception
  - [ ] Unwind
  - [x] dl
		- replaced by WinApi
- [x] value
- [x] struct
- [x] proc
- [x] thread
- [x] gc
- [x] gc/null
- [x] gc/boehm
  - with pre-built (gc-lib.lib)[https://dl.dropboxusercontent.com/u/1707310/Crystal/gc-lib.lib]
- [x] class
- [x] comparable
- [x] enumerable
- [x] iterable
- [x] iterator
- [x] nil
- [x] bool
- [x] char
- [x] number
- [x] int
- [x] float
- [x] pointer
- [x] slice
- [x] range
- [x] char/reader
- [x] string
- [x] symbol
- [x] enum
- [x] static_array
- [x] array
- [x] hash
- [x] set
- [x] tuple
- [x] box
- [x] math/math
- [ ] process
- [ ] io
- [ ] env
- [ ] file
- [ ] dir
- [x] time
- [x] random
- [x] regex
  - with pre-built (libpcre.lib)[https://dl.dropboxusercontent.com/u/1707310/Crystal/libpcre.lib]
- [ ] raise
- [ ] errno
- [x] concurrent
  - [x] libevent (event2)
    - with pre-built (libevent.lib)[https://dl.dropboxusercontent.com/u/1707310/Crystal/libevent.lib]
- [ ] signal
- [ ] kernel
  - [ ] AtExitHandlers
  - [ ] Process/Fiber cleaning
- [ ] main
  - [ ] use normal `main`

## Other

- [x] fiber
  - with pre-built (pcl.lib)[https://dl.dropboxusercontent.com/u/1707310/Crystal/pcl.lib]
- [ ] winapi `New prelude`
  - [ ] kernel32
    - [x] mmap

# Cross compiling Crystal for Windows from Linux

## Target code

code.cr:

```
lib C
    fun puts(str : UInt8*) : Int32
end

class String
    def cstr
        pointerof(@c)
    end
end

C.puts "Hello World!".cstr
```

## Compile Crystal into LLVM bytecode on Linux and compile to executable on Windows with TDM-GCC

TDM-GCC: 5.1.0 32bit
LLVM llc: 3.4
Clang: 3.6

Build Crystal on Linux first, and we are going to use this build below: (we set crystal was built in `crystal/.build`)

1. Compile Crystal code to LLVM bytecode on Linux

    $ DUMP=1 PATH="crystal/.build" crystal build --single-module --cross-compile "windows x86_64" code.cr 2> code.ll
    cc code.o -o code -rdynamic
    $

2. Compile LLVM bytecode to assembly on Windows

    > llc code.ll -o code.s
    >

3. Compile assembly to executeable on Windows (this will use GNU ld in TDM-GCC pack)

    > clang code.s -o code.exe
    >

4. Execute on Windows

    > code.exe
    Hello, World
    >

## Compile Crystal into LLVM bytecode on Linux and compile to executable on Windows with MSVC

MSVC: 14.0
LLVM llc: 3.4

Build Crystal on Linux first, and we are going to use this build below: (we set crystal was built in `crystal/.build`)

1. Compile Crystal code to LLVM bytecode on Linux

    $ DUMP=1 PATH="crystal/.build" crystal build --single-module --cross-compile "windows x86_64" code.cr 2> code.ll
    cc code.o -o code -rdynamic
    $

2. Compile LLVM bytecode to object code on Windows

    > llc -filetype=obj -o code.obj code.ll
    >

3. Link with MSVC on Windows

    > link /defaultlib:libcmt /OUT:code.exe code.obj
    >

4. Execute on Windows

    > code.exe
    Hello, World
    >

# Notes

1. Clang version should be 3.6 or higher. (tested with 3.7.1)
2. `llc` is passed with 3.4. (It's to hard to find prebuilt on 3.6)
3. Use `llc` on windows for generating windows symbols.
4. Still working on compiling the compiler now.

