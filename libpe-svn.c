#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

//function for pwdx-svn
int mypwdx(char *pid, char *bufff, size_t size)
{
        //sozdaem bufer dlya vivoda
//        char bufff[256];
        //formiruem stroku processa
        char part1[256]="/proc/";
        strcat(part1, pid);
        strcat(part1, "/cwd");
        //delaem sys vizov (man 2 readlink)
        int len;
        len = readlink(part1, bufff, size);
	//dobavlyaem konec
	bufff[len] = '\0';
        //proverka dlini
        if (len < 0)
        {
          printf("No exist process: %s\n", pid);
          return 1;
        }
	return 0;
}

//function for envx-svn
int myenvx(char *cmdarg2)
{
        //formiruem put` k failu
        char part2[256]="/proc/";
        strcat(part2, cmdarg2);
        strcat(part2, "/environ");
        //open file env only read
        FILE *myfile;
        myfile = fopen(part2, "r");
        if ( !myfile )
        {
          printf("The file isn't present or it is unavailable\n");
          return 1;
        }
        char c;
        do
        {
          c = fgetc(myfile);
          //esli nado, to menyaem konec stroki na perenos stroki
          if ( c == '\0' )
          {
            c = '\n';
          }
          printf("%c", c);
        }
        while ( c != EOF );
        //zakrivaem file
        fclose(myfile);
	return 0;
}