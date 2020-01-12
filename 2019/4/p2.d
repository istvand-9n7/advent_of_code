#!/usr/bin/env rdmd

import std.range: iota;
import std.stdio: writeln;
import std.typecons: Tuple, tuple;


alias pw = int[6];

struct Password6 {

    pw _pw;

    this(in pw pw) {
        // TODO validate digit range
        _pw = pw.dup;
    }

    this(int pw) {
        // TODO validate length
        _pw = int_to_pw(pw);
        writeln(_pw);
    }

    this(ref return scope Password6 rhs) {
        this._pw = rhs._pw.dup;
    }

    void _carry() {
        auto carry = false;
        if (_pw[$-1] == 10) {
            _pw[$-1] = 0;
            carry = true;
        }
        foreach_reverse (idx, digit; _pw[0..$-1]) {
            if (carry) {
                _pw[idx] += 1;
                carry = false;
            }
            if (_pw[idx] == 10) {
                _pw[idx] = 0;
                carry = true;
            }
        }
    }

    // TODO functional design (return Password6)?
    void incr() {
        this._pw[$-1] += 1;
        this._carry();
    }

    // TODO opAdd for int

    bool valid() {
        // dunno how to select the external function in case of a name clash
        return check_valid(this._pw);
    }

    int opCmp(ref const Password6 rhs) const {
        // TODO think about private _pw-s
        // this._pw.opCmp(rhs._pw)  // did not work because undefidedness for parameter const(int[6])- how to forward then?
        if (this._pw < rhs._pw) return -1;
        if (this._pw > rhs._pw) return 1;
        if (this._pw == rhs._pw) return 0;
        return 0;
    }

}

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

bool check_valid(in pw pw) {
    return check_increase(pw) && check_dup(pw);
}

pw int_to_pw(int num) {
    pw digits;
    foreach (i; iota(5,-1,-1)){
        digits[i] = num % 10;
        num /= 10;
    }
    return digits;
}

Password6[] naive_generate(int low, int high) {
    auto low_pw = Password6(low);
    auto high_pw = Password6(high);
    auto current = low_pw;
    // assert(current !is low_pw);  // how to test for identity?
    Password6[] result = [];
    while (current < high_pw) {
        if (current.valid()) {
            //writeln(current);
            result ~= current;
        }
        current.incr();
    }
    return result;
}



void main() {
    pw[2] bounds = [[1,7,2,9,3,0], [6,8,3,0,8,2]];
    auto bounds_int = [172930, 683082];
    auto repeat = false;
    auto highest = bounds[0][0];

    auto res = naive_generate(bounds_int[0], bounds_int[1]);
    writeln(res.length);
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
