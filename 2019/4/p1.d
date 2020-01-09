#!/usr/bin/env rdmd

import std.range: iota;
import std.stdio: writeln;
import std.typecons: Tuple, tuple;


alias pw = int[6];

bool check_increase(pw pw) {
    int prev = pw[0];
    foreach (digit; pw[1..$]) {
        if (prev > digit) {
            return false;
        }
        prev = digit;
    }
    return true;
}

bool check_dup(pw pw) {
    int prev = pw[0];
    foreach (digit; pw[1..$]) {
        if (prev == digit) {
            return true;
        }
        prev = digit;
    }
    return false;
}

bool check_valid(pw pw) {
    return check_increase(pw) && check_dup(pw);
}


pw[] naive_generate(pw low, pw high) {
    pw current = low.dup;
    pw[] result = [];
    while (current < high) {
        if (check_valid(current)) {
            result ~= current;
        }
        current[$-1] += 1;  // only increasing the last digit
        // all the other increase is via carry
        auto carry = false;
        if (current[$-1] == 10) {
            current[$-1] = 0;
            carry = true;
        }
        foreach_reverse (idx, digit; current[0..$-1]) {
            if (carry) {
                current[idx] += 1;
                carry = false;
            }
            if (current[idx] == 10) {
                current[idx] = 0;
                carry = true;
            }
        }
        writeln(current);
    }
    return result;
}

pw int_to_pw(int num) {
    pw digits;
    foreach (i; iota(5,-1,-1)){
        digits[i] = num % 10;
        num /= 10;
    }
    return digits;
}

int[] naive_generate(int low, int high) {
    int[] result = [];
    while (low < high) {
        auto digits = int_to_pw(low);
        if (check_valid(digits)) {
            writeln(low);
            result ~= low;
        }
        low++;
    }
    return result;
}


void main() {
    pw[2] bounds = [[1,7,2,9,3,0], [6,8,3,0,8,2]];
    auto bounds_int = [172930, 683082];
    auto repeat = false;
    auto highest = bounds[0][0];

    // writeln(bounds[1] > bounds[0]);  // array comparisons work, great!
    //writeln(int_to_pw(172930), int_to_pw(683082));
    writeln(naive_generate(bounds[0], bounds[1]).length);
    //writeln(naive_generate(bounds_int[0], bounds_int[1]).length);
}


unittest {
    Tuple!(pw,bool)[] tcs = [
        tuple(cast(pw)[1,1,1,1,1,1], true),
        tuple(cast(pw)[2,2,3,4,5,0], false),
        tuple(cast(pw)[1,2,3,7,8,9], false)
    ];
    foreach (testcase; tcs) {
        assert(check_valid(testcase[0]) == testcase[1]);
    }
}
