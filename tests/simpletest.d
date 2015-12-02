module simpletest;

import std.stdio;
import std.math;

import importedstuff;

/**
Test of function comments.
*/
void writeln(string text)
{
	
}

/**
 * Test of comments.
 */
class Test
{
	int test()
	{
		return 2;
	}
}

void main(string[] args)
{
	Test test, test2;
	test.test();
	int alpha = 5;
	int b = max(alpha, 1);
	int c = alpha + b;
	alpha;
	string hello = "Hello world!";
	writeln(hello);
	while(alpha > 3)
		alpha--;
	for(int i=0; i<10; i++)
		alpha += i;
}
