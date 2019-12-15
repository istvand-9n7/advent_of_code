#!/usr/bin/env rdmd

import std.algorithm.searching : find;
import std.stdio : writeln;
import std.range : chunks;

enum
{
    OP_ADD = 1,
    OP_MUL = 2,
    OP_RET = 99
}

void opAdd(int arg1, int arg2, out int outpos)
{
    outpos = arg1 + arg2;
}

void opMul(int arg1, int arg2, out int outpos)
{
    outpos = arg1 * arg2;
}

// no opRet: handled by explicit return

void validate(int[] mem)
{
    foreach (seq; mem.chunks(4))
    {
        if (![OP_ADD, OP_MUL].find(seq[0]))
        {
            if (seq[0] == OP_RET)
            {
                return; // don't care what comes after 99
            }
            throw new Exception("Effed");
        }
    }
}

void compute(ref int[] mem)
{
    foreach (seq; mem.chunks(4))
    {
        final switch (seq[0]) {
            case OP_ADD:
                opAdd(mem[seq[1]], mem[seq[2]], mem[seq[3]]);
                break;
            case OP_MUL:
                opMul(mem[seq[1]], mem[seq[2]], mem[seq[3]]);
                break;
            case OP_RET:
                return;
        }
    }
}

void main()
{
    // dfmt off
    int[] mem = [
        1, 0, 0, 3, 
        1, 1, 2, 3, 
        1, 3, 4, 3, 
        1, 5, 0, 3, 
        2, 13, 1, 19, 
        1, 10, 19, 23, 
        1, 23, 9, 27, 
        1, 5, 27, 31, 
        2, 31, 13, 35, 
        1, 35, 5, 39, 
        1, 39, 5, 43, 
        2, 13, 43, 47, 
        2, 47, 10, 51, 
        1, 51, 6, 55, 
        2, 55, 9, 59, 
        1, 59, 5, 63, 
        1, 63, 13, 67, 
        2, 67, 6, 71, 
        1, 71, 5, 75, 
        1, 75, 5, 79, 
        1, 79, 9, 83, 
        1, 10, 83, 87, 
        1, 87, 10, 91, 
        1, 91, 9, 95, 
        1, 10, 95, 99,
        1, 10, 99, 103, 
        2, 103, 10, 107, 
        1, 107, 9, 111, 
        2, 6, 111, 115, 
        1, 5, 115, 119, 
        2, 119, 13, 123, 
        1, 6, 123, 127, 
        2, 9, 127, 131, 
        1, 131, 5, 135, 
        1, 135, 13, 139, 
        1, 139, 10, 143, 
        1, 2, 143, 147, 
        1, 147, 10, 0,
        99, 2, 0, 14, 
        0
    ];
    // dfmt on

    mem[1] = 12;
    mem[2] = 2;

    validate(mem);
    compute(mem);
    writeln(mem[0]);
}
