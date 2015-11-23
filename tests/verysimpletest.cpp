#include "importedstuff_cpp.cpp"

using namespace importedstuff_cpp;

namespace verysimplestuff
{

void main(int argc, char** argv)
{
	int a = add(1, 5);
	int b = testConstant;
	int c = importedstuff_cpp::testConstant;
}

}
