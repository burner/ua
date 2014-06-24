module ua.insertgen1;

import ua.uda;

string genInsert1(T)() if(isUA!T) {
	import std.algorithm : filter, joiner, iota, map;
	import std.stdio : writeln;
	import std.conv : to;
	import std.range : repeat, take;

	string[string] namesInUse;

	string ret = "INSERT INTO " ~ getName!T ~ " (";

	size_t cnt = 0;

	bool first = false;
	foreach(mem; __traits(allMembers, T)) {
		static if(isUA!(T, mem)) {
			if(mem in namesInUse) {
				continue;
			} else {
				ret ~= first ? ", " : "";
				ret ~= getUA!(T, mem)().rename;
				first = true;
				++cnt;
			}
		}
	}

	ret ~= ") VALUES(";

	ret ~= repeat("?").take(cnt).joiner(",").to!string;

	ret ~= ");";

	return ret;
}
