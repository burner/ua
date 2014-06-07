import ua.where;
import ua.util.type;
import ua.util.eightylineformat;
import ua.ctfetrie;
import ua.options;
import ua.uda;
import ua.mysql;

void main() {
	struct Foo {
		@UA string a;
		@UA("someothername") int b;
	}

	auto db = MySQL();

	auto w1 = where!(Foo, "a")(Op.EQ, "whatever");
	auto w2 = where!(Foo, "b", Op.GE)(10);

	Where[] wheres;
	wheres ~= w1;
	wheres ~= w2;

	foreach(it; db.select!Foo(w1, w2)) {
	}

	foreach(it; db.select!Foo(wheres)) {
	}
}
