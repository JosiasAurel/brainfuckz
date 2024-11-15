const std = @import("std");

const DATA_ARRAY_SIZE: usize = 30000;

const BrainfuckMachine = struct {
    ip: usize = 0, // instruction pointer
    dp: usize = 0, // data pointer
    data_array: [DATA_ARRAY_SIZE]u8 = [_]u8{0} ** DATA_ARRAY_SIZE,
    debug: bool = false,
    // var open_brackets_count: u32 = 0;

    fn run(Self: *BrainfuckMachine, code: []const u8) !void {
        while (Self.*.ip < code.len) {
            const char = code[Self.*.ip];
            switch (char) {
                '>' => {
                    Self.*.dp += 1;
                },
                '<' => {
                    Self.*.dp -= 1;
                },
                '+' => {
                    Self.*.data_array[Self.*.dp] += 0x1;
                },

                '-' => {
                    Self.*.data_array[Self.*.dp] -= 0x1;
                },

                '.' => {
                    const byte = Self.*.data_array[Self.*.dp];
                    std.debug.print("{c}", .{byte});
                },

                ',' => {
                    const stdin = std.io.getStdIn().reader();
                    Self.*.data_array[Self.*.dp] = stdin.readByte() catch unreachable;
                },

                '[' => {
                    var open_brackets_count: u32 = 1;
                    const byte = Self.*.data_array[Self.*.dp];
                    if (byte == 0x0) {
                        while (open_brackets_count != 0) {
                            Self.*.ip += 1;
                            const _char = code[Self.*.ip];
                            switch (_char) {
                                '[' => {
                                    open_brackets_count += 1;
                                },
                                ']' => {
                                    open_brackets_count -= 1;
                                },
                                else => {}, // noop
                            }

                            // std.debug.print("[Loop / I -> {any} | Data -> {any}@{any}\n", .{ Self.*.ip, Self.*.data_array[Self.*.dp], Self.*.dp });
                        }
                    }
                },

                ']' => {
                    // std.debug.print("Get's here 1\n", .{});
                    var closed_brackets_count: u32 = 1;
                    const byte = Self.*.data_array[Self.*.dp];

                    if (byte != 0x0) {
                        while (closed_brackets_count != 0) {
                            Self.*.ip -= 1;
                            const _char = code[Self.*.ip];
                            switch (_char) {
                                '[' => {
                                    closed_brackets_count -= 1;
                                },
                                ']' => {
                                    closed_brackets_count += 1;
                                },
                                else => {},
                            }

                            // std.debug.print("]Loop / I -> {any} | Data -> {any}@{any}\n", .{ Self.*.ip, Self.*.data_array[Self.*.dp], Self.*.dp });
                        }
                    }
                    // Self.*.ip += 1;
                },
                else => {},
            }
            // std.debug.print("I -> {any} | Data -> {any}@{any}\n", .{ Self.*.ip, Self.*.data_array[Self.*.dp], Self.*.dp });
            // go to the next instruction
            Self.*.ip += 1;
        }
    }

    fn read_input() void {
        std.io.getStdIn().reader();
    }

    fn inspect_internals(Self: *BrainfuckMachine, code: []const u8) void {
        std.debug.print("{s}\n", .{code});
        std.debug.print("{s}^\n", .{" " * Self.*.ip});
    }
};

pub fn main() !void {
    var machine = BrainfuckMachine{};
    // const test_str = "++ > +++++ [ <+ >- ] ++++ ++++ [ <+++ +++ >- ] < .";
    // Hello World
    // const test_str = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.";
    // const test_str = "+++++[-]";
    // print's the letter 'A' to the console
    // const test_str = "----[---->+<]>++.";
    // Add two numbers
    // const test_str = "  ++ > +++++ [ <+ >- ] ++++ ++++ [ <+++ +++ >- ] < .";
    // Generate random bytes
    // const test_str = "  >>>++[ <++++++++[ <[<++>-]>>[>>]+>>+[ -[->>+<<<[<[<<]<+>]>[>[>>]]] <[>>[-]]>[>[-<<]>[<+<]]+<< ]<[>+<-]>>- ]<.[-]>> ]";
    // Theumorse code generator
    // const test_str = "  >>++++++[>++++++++<-]+[[>.[>]+<<[->-<<<]>[>+<<]>]>++<++]";
    // Other hello world
    // const test_str = "++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++.>+.+++++++..+++.<<++++++++++++++.------------.>+++++++++++++++.>.+++.------.--------.<<+.";
    // const test_str = "--[----->+<]>---.++++++++++++.+.+++++++++.+[-->+<]>+++.++[-->+++<]>.++++++++++++.+.+++++++++.-[-->+++++<]>++.[--->++<]>-.-----------.";
    // Triangles
    // const test_str = ">++++[<++++++++>-]>++++++++[>++++<-]>>++>>>+>>>+<<<<<<<<<<[-[->+<]>[-<+>>>.<<]>>>[[->++++++++[>++++<-]>.<<[->+<]+>[->++++++++++<<+>]>.[-]>]]+<<<[-[->+<]+>[-<+>>>-[->+<]++>[-<->]<<<]<<<<]++++++++++.+++.[-]<]+++++";
    const test_str = ",.";

    // [[[[]]]]-
    // popping an item on the stack leaves us with (index) number of items on the stack
    // ^ for matching square brackets
    // the matching opening/closing square bracket we should stop at is whichever
    // will pop the current opening or closing on the stack

    machine.run(test_str) catch unreachable;
    // expected result: 7
}
