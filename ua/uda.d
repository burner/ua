module ua.uda;

import std.conv;
import std.traits;

import ua.options;
import ua.util.type;

private void buildUARecursive(Args...)(ref UA ua, Args args) {
	static if(args.length > 0) {
		//auto v = args[0];
		static if(isSomeString!(typeof(args[0]))) {
			ua.rename = args[0];
		} else {
			if(args[0] == PrimaryKey) {
				ua.isPrimaryKey = true;
			} else if(args[0] == NotNull) {
				ua.isNotNull = true;
			}
		}
	}

	static if(args.length > 1) {
		buildUARecursive(ua, args);
	}
}

/** By default all data member of an struct or class will be considered when
used in UniformAccess, the UA attribute makes the usage more verbose and
allows to provide additional options.
*/
struct UA {
	static UA opCall(T...)(T args) {
		UA ret;
		buildUARecursive(ret, args);
		return ret;
	}

	string rename;
	bool isPrimaryKey;
	bool isNotNull;
}

/** Whatever has an NoUA attribute will not be considered in UniformAccess
*/
enum {
	NoUA
}

version(unittest) {
	@UA("AName") struct SomeCrazyNameYouShouldNeverWrite {
		@UA int a;
		@NoUA float b;
		@UA("foo") string c;

		@UA(PrimaryKey) @property int fun() { return fun_; }
		@UA(PrimaryKey) @property void fun(int f) { fun_ = f; }

		private int fun_;
	}
}

UA getUA(T)() {
	static assert(isUA!(T));

	foreach(it; __traits(getAttributes, T)) {
		if(is(typeof(it) == UA)) {
			UA ret;
			ret.rename = it.rename;
			ret.isPrimaryKey = it.isPrimaryKey;
			ret.isNotNull = it.isNotNull;

			return ret;
		}
	}

	assert(false);
}

unittest {
	UA u = getUA!SomeCrazyNameYouShouldNeverWrite();
	assert(u.rename == "AName");
}

UA getUA(T, string member)() {
	static assert(isUA!(T, member));

	foreach(it; __traits(getAttributes, __traits(getMember, T, member))) {
		if(is(typeof(it) == UA)) {
			UA ret;
			ret.rename = it.rename;
			ret.isPrimaryKey = it.isPrimaryKey;
			ret.isNotNull = it.isNotNull;

			return ret;
		}
	}

	assert(false);
}

unittest {
	UA u = getUA!(SomeCrazyNameYouShouldNeverWrite, "c")();
	assert(u.rename == "foo", to!string(u));
}

bool isUAImpl(T)() {
	string ua = getNameOf!T;
	string noUA = to!string(NoUA);

	foreach(it; __traits(getAttributes, T)) {
		if(is(typeof(it) == UA)) {
			return true;
		}
	}

	return true;
}

bool isUAImpl(T, string member)() {
	string ua = getNameOf!T;
	string noUA = to!string(NoUA);

	foreach(it; __traits(getAttributes, __traits(getMember, T, member))) {
		if(is(typeof(it) == UA)) {
			return true;
		}
	}

	return true;
}

bool isUA(T)() {
	return isUAImpl!(T)();
}

bool isNotUA(T)() {
	return !isUAImpl!(T)();
}

unittest {
	static assert(isUA!(SomeCrazyNameYouShouldNeverWrite));
	static assert(!isNotUA!(SomeCrazyNameYouShouldNeverWrite));
}

bool isUA(T, string member)() {
	return isUAImpl!(T,member)();
}

bool isNotUA(T, string member)() {
	return !isUAImpl!(T,member)();
}

unittest {
	static assert(isUA!(SomeCrazyNameYouShouldNeverWrite,"a"));
	static assert(!isNotUA!(SomeCrazyNameYouShouldNeverWrite,"a"));
}
