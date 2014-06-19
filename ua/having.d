module ua.having;

import std.conv;

import ua.wherehavingimpl;
import ua.operator;
import ua.types;

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
