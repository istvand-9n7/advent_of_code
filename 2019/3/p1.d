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

auto manhattan(GridPoint pt1, GridPoint pt2) {
    return abs(pt1.x - pt2.x) + abs(pt1.y - pt2.y);
}

auto process_section(char[] section) {
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

auto coord_list(char[][] wire_reading) {
    auto loc = [0,0];
    foreach (instr; wire_reading) {
        process_section(instr);
    }

}

void main() {
    auto input_file = File("input.txt", "r");
    scope(exit) input_file.close();
    auto wire_readings = input_file.byLine.map!(a => a.split(","));
    // writeln(typeid(wire_readings)); // p1.main.MapResult!(__lambda1, ByLineImpl!(char, char)).MapResult // LOL
    foreach (wire_reading; wire_readings){
        coord_list(wire_reading.array());
    }

}