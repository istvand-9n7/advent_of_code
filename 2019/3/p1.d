#!/usr/bin/env rdmd

import std.algorithm: map;
import std.array;
import std.stdio : File, writeln;
import std.string;

void main() {
    auto input_file = File("input.txt", "r");
    scope(exit) input_file.close();
    auto wire_readings = input_file.byLine.map!(a => a.split(","));
    writeln(typeid(wire_readings)); // p1.main.MapResult!(__lambda1, ByLineImpl!(char, char)).MapResult // LOL

}