module ua.updategen1;

import ua.uda;

string genUpdate1(T,string placeHolder)() nothrow @trusted if(isUA!T) {
	string[string] namesInUse;

	string ret = "UPDATE " ~ getName!T ~ " (";

	size_t cnt = 0;

	bool first = false;
	foreach(mem; __traits(allMembers, T)) {
		static if(isUA!(T, mem) && ) {
			UA ua = getUA!(T, mem);
			if(mem in namesInUse || ua.isPrimaryKey) {
				continue;
			} else {
				ret ~= first ? ", " : "";
				ret ~= ua.rename;
				first = true;
				++cnt;
			}
		}
	}

}
