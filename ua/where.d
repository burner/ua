module ua.where;

import std.conv;

import ua.wherehavingimpl;
import ua.operator;
import ua.util.type;

struct Where {
	string t;
	string member;
	Op op;
	string value;
}

mixin(getHavingWhereFunctions!("where", "Where")());

unittest {
	mixin(getWhereUnittestString());
}
