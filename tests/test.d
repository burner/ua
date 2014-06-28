import std.stdio;

import std.array;
import std.conv;
import ua.ctfetrie;
import ua.groupby;
import ua.mysql;
import ua.postgresql;
import ua.operator;
import ua.options;
import ua.uda;
import ua.util.eightylineformat;
import ua.types;
import ua.where;
import ua.tablegen1;
import ua.insertgen1;
import ua.updategen1;

void main() {
	@UA struct Foo {
		@UA string a;
		@UA(PrimaryKey, "someothername") int b;
	}

	auto db = MySQL();

	auto w1 = where!(Foo, "a")(Op.EQ, "whatever");
	auto w2 = where!(Foo, "b", Op.GE)(10);

	Where[] wheres;
	wheres ~= w1;
	wheres ~= w2;

	auto g1 = GroupBy("a");

	foreach(it; db.select!Foo(w1, w2)) {
	}

	foreach(it; db.select!Foo(wheres)) {
	}

	enum ct1 = genCreateTable1!(Foo, mysqlType)();
	writeln(ct1);

	enum i = genInsert1!(Foo,MySQLPlaceholderGen)();
	writeln(i);
	enum i2 = genInsert1!(Foo,PostgreSQLPlaceholderGen)();
	writeln(i2);

	enum u1 = genUpdate1!(Foo,MySQLPlaceholderGen)();
	writeln(u1);

	enum u2 = genUpdate1!(Foo,PostgreSQLPlaceholderGen)();
	writeln(u2);
}
