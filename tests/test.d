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
import ua.deletegen1;
import ua.selectgen1;
import ua.mysql;

void main() {
	@UA struct Foo {
		@UA string a;
		@UA int b;
		@UA(PrimaryKey, "k1") int c;
		@UA(PrimaryKey, "k2") int d;
	}

	auto db = MySQL("localhost", "root", "mariadbpwd");

	auto w1 = where!(Foo, "a")(Op.EQ, "whatever");
	auto w2 = where!(Foo, "b", Op.GE)(10);

	Where[] wheres;
	wheres ~= w1;
	wheres ~= w2;

	auto g1 = GroupBy("a");

	/*foreach(it; db.select!Foo(w1, w2)) {
	}

	foreach(it; db.select!Foo(wheres)) {
	}*/

	enum ct1 = genCreateTable1!(Foo, mysqlType)();
	writeln(ct1);

	enum i = genInsert1!(Foo,MySQLPlaceholderGen)();
	writeln(i);
	enum i2 = genInsert1!(Foo,PostgreSQLPlaceholderGen)();
	writeln(i2);

	Foo f;
	db.insert(f);

	enum u1 = genUpdate1!(Foo,MySQLPlaceholderGen)();
	writeln(u1);

	enum u2 = genUpdate1!(Foo,PostgreSQLPlaceholderGen)();
	writeln(u2);

	enum d1 = genDelete!(Foo,MySQLPlaceholderGen)();
	writeln(d1);

	enum d2 = genDelete!(Foo,PostgreSQLPlaceholderGen)();
	writeln(d2);
}
