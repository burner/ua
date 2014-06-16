import ua.ctfetrie;
import ua.groupby;
import ua.mysql;
import ua.operator;
import ua.options;
import ua.uda;
import ua.util.eightylineformat;
import ua.util.type;
import ua.where;
import ua.tablegen1;

void main() {
	@UA() struct Foo {
		@UA() string a;
		@UA("someothername") int b;
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

	string ct1 = genCreateTable1!Foo;
}
