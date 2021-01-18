//#include <sys/types.h>
//#include <sys/stat.h>
//#include <fcntl.h>
#include <stdio.h>
#include <string.h>

#define _GNU_SOURCE
#include <dlfcn.h>

#define BUF_SIZE 256
#define HARD_PREFIX "/usr/share"

#include <nl_types.h>
#include <stdlib.h>

typedef nl_catd (*orig_catopen_f_type)(const char *pathname, int flags);


nl_catd catopen(const char *name, int flag) {
	char buf[BUF_SIZE];
	const char * prefix = getenv("NIX_ZED_PREFIX");

	memset(buf, 0, BUF_SIZE);

	orig_catopen_f_type orig_catopen;
	printf("meh\n");
    orig_catopen = (orig_catopen_f_type)dlsym(RTLD_NEXT,"catopen");
	printf("moh\n");

	if (prefix == NULL || strlen(name) < sizeof(HARD_PREFIX))
	    return orig_catopen(name, flag);


	printf("path: %s prefix: %s %d\n", name, HARD_PREFIX, sizeof(HARD_PREFIX));
	printf("memcmp %d\n", (memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1)));

	if (memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1) == 0) {
		int prefix_len = strnlen(prefix, 256);
		memmove(buf, prefix, prefix_len);
		memmove(buf + prefix_len, name + sizeof(HARD_PREFIX), strlen(name) - sizeof(HARD_PREFIX));
		printf("changing path for %s (new path %s)\n", name, buf);
	    return orig_catopen(buf, flag);
	} else
	    return orig_catopen(name, flag);
}