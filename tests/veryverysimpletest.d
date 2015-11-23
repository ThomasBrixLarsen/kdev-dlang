module veryverysimpletest;

int testConstant = 10;

int add(int a, int b)
{
	return a + b;
}

void main(string[] args)
{
	int a = add(1, 5);
	int b = testConstant;
}
