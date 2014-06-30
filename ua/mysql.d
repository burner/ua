module ua.mysql;

import std.exception : enforceEx;

import ua.uda;

struct MySQLPlaceholderGen {
	@property string front() pure @safe nothrow { return "?"; }

	bool empty = false;

	void popFront() pure @safe nothrow {}
}

private immutable MySQLExceptionConstructor = q{
	this(string msg = "", string file = __FILE__, ulong line = __LINE__) {
		super(msg, file, line);
	}
};

class MySQLException : Exception {
	mixin(MySQLExceptionConstructor);
}

/** Is thrown if the MYSQL pointer points to null */
class MySQLIsNullException : MySQLException {
	mixin(MySQLExceptionConstructor);
}

/** Is thrown if the mysql_init fails */
class MySQLInitException : MySQLException {
	mixin(MySQLExceptionConstructor);
}

struct MySQL {
	import std.allocator;
	import ua.mysqlcbinding;

  private:
	string url;
	string username;
	string password;
	MYSQL* dbConnection;

	Mallocator m;

  public:
	this(string url, string username, string password) {
		this.url = url;
		this.username = username;
		this.password = password;

		this.dbConnection = enforceEx!MySQLInitException(mysql_init(null));
	}

	void insert(T)(ref T t) {
		import ua.insertgen1;
		import std.stdio : writefln;

		enforceEx!MySQLIsNullException(this.dbConnection);

		enum insertStmt = genInsert1!(T, MySQLPlaceholderGen);
		auto stmt = mysql_stmt_init(this.dbConnection);
	}
}
