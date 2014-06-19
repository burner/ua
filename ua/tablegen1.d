module ua.tablegen1;

import ua.uda;

// MySQL / SQL Server / Oracle / MS Access:
string genCreateTable1(T, alias TypeGen)() if(isUA!T) {
	static assert(isUA!T());
	string[string] namesInUse;

	string ret = "CREATE TABLE ";
	ret ~= getName!T();

	foreach(mem; __traits(allMembers, T)) {
		static if(isUA!(T, mem)) {
			if(mem in nameInUse) {
				continue;
			} else {
				ret ~= uaToTable(getUA!(T, mem), mem);
			}
		}
	}

	return ret;
}

pure string uaToTable(UA ua, string mem) {
	import std.string;
	import std.array;

	return format("%s%s", ua.rename.empty() ? mem : ua.rename,
		ua.isNotNull ? " NOT NULL," : ",");
}
