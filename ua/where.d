/** This module is about creating where statements for various sql version.

Where statements can be created at compile time, at runtime and partially at
compile time.
*/
module ua.where;

import std.stdio;
import std.traits;
import std.string;
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

/*Where where(T, string member, Op op, long value)() {
	Where ret;
	ret.t = getNameOf!T;
	ret.member = member;
	ret.op = op;
	ret.value = to!string(value);
	return ret;
}*/

unittest {
	struct Foo {
		int a;
	}

	auto w = where!(Foo, "a", Op.EQ, 10);
	w = where!(Foo, "a", Op.EQ, true);
}

alias TypeTuple!(bool, char, byte, short, int, long,
	ubyte, ushort, uint, ulong, float, double, real, 
	string, wstring, dstring) UATypes;

immutable whereFuncTempAll = q{
	Where where(T, string member, Op op, %s value)() pure @safe {
		Where ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

immutable whereFuncTempValue = q{
	Where where(T, string member, Op op, S)(S value) pure @safe {
		Where ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

immutable whereFuncTempOp = q{
	Where where(T, string member, %s value)(Op op) pure @safe {
		Where ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

immutable whereFuncTempValueOp = q{
	Where where(T, string member, S)(S value, Op op) pure @safe {
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

pragma(msg, getWhereFunctions());
mixin(getWhereFunctions());
