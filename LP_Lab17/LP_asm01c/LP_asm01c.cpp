#include <iostream>
#pragma comment (lib, "..\\Debug\\LP_asm01a.lib")

extern "C"
{
	int __stdcall getmax(int*, int);
	int __stdcall getmin(int*, int);
}

int main()
{
	int mas[10] = { -10, 15, -23, 4, 2, 8, 34, 11, -16, 27 };
	int max = getmax(mas, sizeof(mas) / sizeof(int));
	int min = getmin(mas, sizeof(mas) / sizeof(int));
	std::cout << "getmax-getmin=" << max - min << std::endl;
	return 0;
}