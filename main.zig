const std = @import("std");

const DATA_ARRAY_SIZE: usize = 30000;

fn MakeBracketStack(comptime size: usize) type {
    return struct {
        var index: usize = 0;
        // var items: [size]u8 = [_]u8{0} ** size;
        var items: [size]u8 = undefined;

        fn push(char: u8) void {
            const Self = @This();
            Self.items[Self.index] = char;
            Self.index += 1;
        }

        fn pop() void {
            const Self = @This();
            Self.index -= 1;
            Self.items[Self.index] = 0;
        }

        // look at items backward
        fn peek() u8 {
            const Self = @This();
            return Self.items[Self.index - 1];
        }

        fn len() usize {
            const Self = @This();
            return Self.items.len;
        }
    };
}

const BrainfuckMachine = struct {
    ip: usize = 0, // instruction pointer
    dp: usize = 0, // data pointer
    data_array: [DATA_ARRAY_SIZE]u8 = [_]u8{0} ** DATA_ARRAY_SIZE,

    fn run(Self: *BrainfuckMachine, code: []const u8) void {
        while (Self.*.ip < code.len) {
            var char = code[Self.*.ip];
            switch (char) {
                '>' => {
                    Self.*.dp += 1;
                },
                '<' => {
                    Self.*.dp -= 1;
                },
                '+' => {
                    // const data = Self.*.data_array[Self.*.dp];
                    // std.debug.print("-> ip {}/{} -> {}\n", .{ Self.*.ip, code.len, data });
                    Self.*.data_array[Self.*.dp] += 0x1;
                },

                '-' => {
                    Self.*.data_array[Self.*.dp] -= 0x1;
                },

                '.' => {
                    const byte = Self.*.data_array[Self.*.dp];
                    // std.debug.print("[BF] -> {c}\n", .{byte});
                    std.debug.print("{c}", .{byte});
                },

                ',' => {
                    // TODO: accept a byte of input
                    @panic("Doesn't support user input yet");
                },

                '[' => {
                    const stack = MakeBracketStack(1000);
                    // std.debug.print("items size = {} \n", .{stack.items.len});
                    // if (true) break;
                    // push stack

                    // std.debug.print("opened\n", .{});
                    const byte = Self.*.data_array[Self.*.dp];
                    if (byte == 0x0) {
                        stack.push('[');
                        const currIndex = stack.index - 1;
                        // std.debug.print("byte value {} \n", .{byte});

                        // TODO: jump forward to after the next matching ']'
                        while (Self.*.ip < code.len) {
                            Self.*.ip += 1;
                            char = code[Self.*.ip];

                            if (char == '[') stack.push(char);
                            if (char == ']') {
                                if (stack.peek() == '[') {
                                    stack.pop();
                                } else stack.push(']');

                                if (currIndex == stack.index) break;
                            }
                        }
                        // Self.*.ip += 1;

                        // stack.pop();
                    }
                },

                ']' => {
                    const substack = MakeBracketStack(1000);

                    // std.debug.print("closed\n", .{});
                    const byte = Self.*.data_array[Self.*.dp];
                    if (byte != 0x0) {
                        substack.push(']');
                        const currIndex = substack.index - 1;

                        // TODO: jump forward to after the next matching '['
                        while (Self.*.ip > 0) {
                            Self.*.ip -= 1;
                            char = code[Self.*.ip];

                            if (char == ']') substack.push(char);
                            if (char == '[') {
                                if (substack.peek() == ']') {
                                    substack.pop();
                                } else substack.push('[');

                                if (currIndex == substack.index) break;
                            }
                        }

                        // Self.*.ip -= 1;
                        // stack.pop();
                        // ckehar = code[Self.*.ip];
                        continue;
                        // ++++[>---3232]+++
                    }
                },
                else => {},
            }

            // go to the next instruction
            Self.*.ip += 1;
        }
    }
};

pub fn main() void {
    var machine = BrainfuckMachine{};
    // const test_str = "++ > +++++ [ <+ >- ] ++++ ++++ [ <+++ +++ >- ] < .";
    // Hello World
    // const test_str = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.";
    // squares
    // const test_str = ">>>>>>>>>>+>++<[ [[<<+>+>-]++++++[<++++++++>-]<-.[-]<<<] ++++++++++.[-]>>>>>[>>>>]<<<<[[<<<+>+>>-]<<<-<]>>++[ [ <<<++++++++++[>>>[->>+<]>[<]<<<<-] >>>[>>[-]>>+<<<<[>>+<<-]]>>>> ]<<-[+>>>>]+[<<<<]> ]>>>[>>>>]<<<<-<<+<< ]";
    // const test_str = ">>>++[ <++++++++[ <[<++>-]>>[>>]+>>+[ -[->>+<<<[<[<<]<+>]>[>[>>]]] <[>>[-]]>[>[-<<]>[<+<]]+<< ]<[>+<-]>>- ]<.[-]>> ]";
    // const test_str = ">>++++++[>++++++++<-]+[[>.[>]+<<[->-<<<]>[>+<<]>]>++<++]";
    // const test_str = ">++++++++++[<++++++++++>-]<->>>>>+++[>+++>+++<<-]<<<<+<[>[>+ >+<<-]>>[-<<+>>]++++>+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]<<[[-]>> >>>>[[-]<++++++++++<->>]<-[>+>+<<-]>[<+>-]+>[[-]<->]<<<<<<<< <->>]<[>+>+<<-]>>[-<<+>>]+>+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]<< <[>>+>+<<<-]>>>[-<<<+>>>]++>+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]< <[>+<[-]]<[>>+<<[-]]>>[<<+>>[-]]<<<[>>+>+<<<-]>>>[-<<<+>>>]+ +++>+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]<<[>+<[-]]<[>>+<<[-]]>>[< <+>>[-]]<<[[-]>>>++++++++[>>++++++<<-]>[<++++++++[>++++++<-] >.<++++++++[>------<-]>[<<+>>-]]>.<<++++++++[>>------<<-]<[- >>+<<]<++++++++[<++++>-]<.>+++++++[>+++++++++<-]>+++.<+++++[ >+++++++++<-]>.+++++..--------.-------.++++++++++++++>>[>>>+ >+<<<<-]>>>>[-<<<<+>>>>]>+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]<<<< [>>>+>+<<<<-]>>>>[-<<<<+>>>>]+>+<[-<->]<[[-]>>-<<]>>[[-]<<+> >]<<<[>>+<<[-]]>[>+<[-]]++>>+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]< +<[[-]>-<]>[<<<<<<<.>>>>>>>[-]]<<<<<<<<<.>>----.---------.<< .>>----.+++..+++++++++++++.[-]<<[-]]<[>+>+<<-]>>[-<<+>>]+>+< [-<->]<[[-]>>-<<]>>[[-]<<+>>]<<<[>>+>+<<<-]>>>[-<<<+>>>]++++ >+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]<<[>+<[-]]<[>>+<<[-]]>>[<<+> >[-]]<<[[-]>++++++++[<++++>-]<.>++++++++++[>+++++++++++<-]>+ .-.<<.>>++++++.------------.---.<<.>++++++[>+++<-]>.<++++++[ >----<-]>++.+++++++++++..[-]<<[-]++++++++++.[-]]<[>+>+<<-]>> [-<<+>>]+++>+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]<<[[-]++++++++++. >+++++++++[>+++++++++<-]>+++.+++++++++++++.++++++++++.------ .<++++++++[>>++++<<-]>>.<++++++++++.-.---------.>.<-.+++++++ ++++.++++++++.---------.>.<-------------.+++++++++++++.----- -----.>.<++++++++++++.---------------.<+++[>++++++<-]>..>.<- ---------.+++++++++++.>.<<+++[>------<-]>-.+++++++++++++++++ .---.++++++.-------.----------.[-]>[-]<<<.[-]]<[>+>+<<-]>>[- <<+>>]++++>+<[-<->]<[[-]>>-<<]>>[[-]<<+>>]<<[[-]++++++++++.[ -]<[-]>]<+<]";

    // const test_str = "++++[++++>---<]>-.---[----->+<]>-.+++[->+++<]>++.++++++++.+++++.";
    // const test_str = "++++[++++>---<]>-.";
    // const test_str = ">>++++++++++[[->+<<++++>]<++[<]>[.>]>.]";
    const test_str = "+[[->]-[-<]>-]>.>>>>.<<<<-.>>-.>.<<.>>>>-.<<<<<++.>>++.";
    // [[[[]]]]
    // popping an item on the stack leaves us with (index) number of items on the stack
    // ^ for matching square brackets
    // the matching opening/closing square bracket we should stop at is whichever
    // will pop the current opening or closing on the stack

    machine.run(test_str);
    // expected result: 7
}

//
//
// [
// [
//
