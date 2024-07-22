# Brainfuckz

A brainfuck implementation in Zig.

## How to build

- Make sure you have Zig version 0.14.0 installed
- If you have `make` installed, run `make` otherwise you can run `zig build-exe main.zig`
- Run the binary

## Example programs

- Add two numbers
```
  ++ > +++++ [ <+ >- ] ++++ ++++ [ <+++ +++ >- ] < .
```

- Print Hello World
```
  ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
```

- Generate random bytes
```
  >>>++[ <++++++++[ <[<++>-]>>[>>]+>>+[ -[->>+<<<[<[<<]<+>]>[>[>>]]] <[>>[-]]>[>[-<<]>[<+<]]+<< ]<[>+<-]>>- ]<.[-]>> ]
```

- Thuemorse code generator
```
  >>++++++[>++++++++<-]+[[>.[>]+<<[->-<<<]>[>+<<]>]>++<++]
```

## Todos

- [ ] Get user input
- [ ] Expand program support (some programs don't work at all in this implementation)
