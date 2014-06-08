module ua.having;

import std.conv;

import ua.wherehavingimpl;
import ua.operator;
import ua.util.type;

struct Having {
	string t;
	string member;
	Op op;
	string value;
}

mixin(getHavingWhereFunctions!("having", "Having")());

unittest {
	mixin(getHavingUnittestString());
}
