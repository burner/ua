/** This module is about creating where statements for various sql version.

Where statements can be created at compile time, at runtime and partially at
compile time.
*/
module ua.wherehavingimpl;

import std.stdio;
import std.traits;
import std.string;
import std.algorithm;
import std.conv;
import std.typecons;
import std.format;

import ua.util.type;
		/*foreach(jt; [Op.EQ, Op.LE, Op.GE, Op.NEQ]) {
			w = %s!(Foo, "a")(jt, to!it(10));
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
				"\"%" ~ "s\" %" ~ "s".format(w.value, it.stringof));
				"\"%" ~ "s\" %" ~ "s".format(w.value, it.stringof));
					//"\"%s\" %s".format(w.value, it.stringof));
					//"\"%s\" %s".format(w.value, it.stringof));
		}*/


immutable unittestString = q{

	struct Foo {
		int a;
	}

	import std.typecons, std.algorithm;
	alias TypeTuple!(char, byte, short, int, long,
		ubyte, ushort, uint, ulong, float, double, real, 
		string, wstring, dstring) UATypes;
	foreach(it; UATypes) {
		auto w = %s!(Foo, "a", Op.EQ, to!it(10));
		assert(w.t == "Foo");
		assert(w.member == "a");
		assert(w.op == Op.EQ);
		assert(w.value.countUntil("10") != -1);

		w = %s!(Foo, "a", Op.EQ)(to!it(10));
		assert(w.t == "Foo");
		assert(w.member == "a");
		assert(w.op == Op.EQ);
		if(!is(it == char) && !is(it == wchar) && !is(it == dchar)) {
			assert(w.value.countUntil("10") != -1);
		} else {
			assert(w.value == "\n");
		}

		foreach(jt; [Op.EQ, Op.LE, Op.GE, Op.NEQ]) {
			w = %s!(Foo, "a")(jt, to!it(10));
			assert(w.t == "Foo");
			assert(w.member == "a");
			assert(w.op == jt);
			if(!is(it == char) && !is(it == wchar) && !is(it == dchar)) {
				assert(w.value.countUntil("10") != -1);
			} else {
				assert(w.value == "\n");
			}
		}

	}

	auto w = %s!(Foo, "a", Op.EQ, true);
};

public string getWhereUnittestString() pure {
	return unittestString.format("where", "where", "where", "where");
}

public string getHavingUnittestString() pure {
	return unittestString.format("having", "having", "having", "having");
}

private immutable whereHavingFuncTempAll = q{
	auto %s(T, string member, Op op, %s value)() @trusted {
		%s ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereHavingFuncTempValue = q{
	auto %s(T, string member, Op op, S)(S value) @trusted {
		%s ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereHavingFuncTempOp = q{
	auto %s(T, string member, %s value)(Op op) @trusted {
		%s ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereHavingFuncTempValueOp = q{
	auto %s(T, string member, S)(Op op, S value) @trusted {
		%s ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

string getHavingWhereFunctions(string a, string A)() pure @safe nothrow {
	string ret;
	try {
		ret ~= whereHavingFuncTempAll.format(a, long.stringof, A);
		ret ~= whereHavingFuncTempAll.format(a, real.stringof, A);
		ret ~= whereHavingFuncTempAll.format(a, string.stringof, A);
		ret ~= whereHavingFuncTempOp.format(a, long.stringof, A);
		ret ~= whereHavingFuncTempOp.format(a, real.stringof, A);
		ret ~= whereHavingFuncTempOp.format(a, string.stringof, A);
		ret ~= whereHavingFuncTempValue.format(a, A);
		ret ~= whereHavingFuncTempValueOp.format(a, A);
	} catch(Exception e) {
		assert(false, e.msg);
	}

	return ret;
}

pragma(msg, getHavingWhereFunctions!("where", "Where"));

//pragma(msg, getWhereFunctions());
//mixin(getHavingWhereFunctions!());
