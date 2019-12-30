#!/usr/bin/env rdmd

import std.algorithm: map;
import std.array;
import std.conv;
import std.math: abs;
import std.stdio : File, writeln;
import std.string;


struct GridPoint {
    int x;
    int y;
}

alias GP = GridPoint;

auto add(GP pt1, GP pt2) {
    return GP(pt1.x+pt2.x, pt1.y+pt2.y);
}

auto manhattan(GP pt1, GP pt2) {
    return abs(pt1.x - pt2.x) + abs(pt1.y - pt2.y);
}

// this one should work as a "join" operation (of the fork/join lore)
auto section_offset(GP[] section, GP offset){
    // I'd like to see it as <array> + scalar = <array>
    // or maybe <array>.offset(scalar) = <array>
    return section.map!(pt => add(pt, offset));
}

auto process_section(const char[] section) {
    int[][] coords = [];
    auto repeat = section[1..$].to!int; 
    switch (section[0]) {
        case 'L':
            foreach (r; 0..repeat+1) {
                coords ~= [-r,0]; 
            }
            break;
        case 'R':
            foreach (r; 0..repeat+1) {
                coords ~= [r,0]; 
            }            
            break;
        case 'U':
            foreach (r; 0..repeat+1) {
                coords ~= [0,r]; 
            }            
            break;
        case 'D':
            foreach (r; 0..repeat+1) {
                coords ~= [0,-r]; 
            }            
            break;
        default:
            // TODO throw exception (or do sthing else if we want nothrow)
            break;
    }
    return coords;
}

auto coord_list(const char[][] wire_reading) {
    auto loc = [0,0];
    foreach (instr; wire_reading) {
        process_section(instr);
    }

}

int process_readings(const char[][][] wire_readings) {
    auto result = 0;
    foreach (wire_reading; wire_readings){
        coord_list(wire_reading);
    }
    return result;
}

void main() {
    auto input_file = File("input.txt", "r");
    scope(exit) input_file.close();
    auto wire_readings = input_file.byLine.map!(a => a.split(","));
    // writeln(typeid(wire_readings)); // p1.main.MapResult!(__lambda1, ByLineImpl!(char, char)).MapResult // LOL
    writeln(process_readings(wire_readings.array));
}


unittest {
    auto input = [
        ["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
        ["U62","R66","U55","R34","D71","R55","D58","R83"]
    ];
    auto expected = 159;
    auto result = process_readings(input);
    writeln(result);
    assert(result == expected);
}

unittest {
    auto input = [
        ["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
        ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]
    ];
    auto expected = 135;
    auto result = process_readings(input);
    writeln(result);
    assert(result == expected);
}