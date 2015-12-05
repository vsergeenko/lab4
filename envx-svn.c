#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "libpe-svn.h"

int main(int argc, char *argv[])
{
	//proverka nali4iya argumente
	if (argc < 2)
	{
	  printf("Vvedite nomer processa!\n");
	  return 1;
	}
        //4itaem argument
        char *cmdarg2 = argv[1];
        //vizov function
        int rez2;
        rez2 = myenvx(cmdarg2);
        //obrabotka oshibki
        if ( rez2 != 0 )
        {
          return 1;
        }
	return 0;
}
