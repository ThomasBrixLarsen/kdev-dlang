module testif;

void main(string[] args)
{
	int a = 10;
	if(a > 2)
	{
		int b = 2;
		a = b;
	}
	else
		a = 4;
	writefln("a: %s", a);
}
