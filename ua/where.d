/** This module is about creating where statements for various sql version.

Where statements can be created at compile time, at runtime and partially at
compile time.
*/
module ua.where;

import std.stdio;
import std.traits;
import std.string;
import std.algorithm;
import std.conv;
import std.typecons;
import std.format;

import ua.util.type;

public enum Op {
	EQ,
	LE,
	GE,
	NEQ
}

struct Where {
	string t;
	string member;
	Op op;
	string value;
}

@safe unittest {
	alias TypeTuple!(char, byte, short, int, long,
		ubyte, ushort, uint, ulong, float, double, real, 
		string, wstring, dstring) UATypes;

	struct Foo {
		int a;
	}

	foreach(it; UATypes) {
		auto w = where!(Foo, "a", Op.EQ, to!it(10));
		assert(w.t == "Foo");
		assert(w.member == "a");
		assert(w.op == Op.EQ);
		assert(w.value.countUntil("10") != -1);

		w = where!(Foo, "a", Op.EQ)(to!it(10));
		assert(w.t == "Foo");
		assert(w.member == "a");
		assert(w.op == Op.EQ);
		if(!is(it == char) && !is(it == wchar) && !is(it == dchar)) {
			assert(w.value.countUntil("10") != -1, 
				"\"%s\" %s".format(w.value, it.stringof));
		} else {
			assert(w.value == "\n",
				"\"%s\" %s".format(w.value, it.stringof));
		}

		foreach(jt; [Op.EQ, Op.LE, Op.GE, Op.NEQ]) {
			w = where!(Foo, "a")(jt, to!it(10));
			assert(w.t == "Foo");
			assert(w.member == "a");
			assert(w.op == jt);
			if(!is(it == char) && !is(it == wchar) && !is(it == dchar)) {
				assert(w.value.countUntil("10") != -1, 
					"\"%s\" %s".format(w.value, it.stringof));
			} else {
				assert(w.value == "\n",
					"\"%s\" %s".format(w.value, it.stringof));
			}
		}
	}
	auto w = where!(Foo, "a", Op.EQ, true);
}


private immutable whereFuncTempAll = q{
	Where where(T, string member, Op op, %s value)() @trusted {
		Where ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereFuncTempValue = q{
	Where where(T, string member, Op op, S)(S value) @trusted {
		Where ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereFuncTempOp = q{
	Where where(T, string member, %s value)(Op op) @trusted {
		Where ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereFuncTempValueOp = q{
	Where where(T, string member, S)(Op op, S value) @trusted {
		Where ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private string getWhereFunctions() pure @safe nothrow {
	string ret;
	try {
		ret ~= whereFuncTempAll.format(long.stringof);
		ret ~= whereFuncTempAll.format(real.stringof);
		ret ~= whereFuncTempAll.format(string.stringof);
		ret ~= whereFuncTempOp.format(long.stringof);
		ret ~= whereFuncTempOp.format(real.stringof);
		ret ~= whereFuncTempOp.format(string.stringof);
		ret ~= whereFuncTempValue;
		ret ~= whereFuncTempValueOp;
	} catch(Exception e) {
		assert(false, e.msg);
	}

	return ret;
}

//pragma(msg, getWhereFunctions());
mixin(getWhereFunctions());
