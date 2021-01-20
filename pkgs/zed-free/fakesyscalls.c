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

#include <sys/stat.h>
#include <unistd.h>
typedef int (*orig__xstat64_f_type) (int ver, const char * path, struct stat64 * stat_buf);


nl_catd catopen(const char *name, int flag) {
	char buf[BUF_SIZE];
	const char * prefix = getenv("NIX_ZED_PREFIX");

	memset(buf, 0, BUF_SIZE);

	orig_catopen_f_type orig_catopen;
    orig_catopen = (orig_catopen_f_type)dlsym(RTLD_NEXT,"catopen");

	if (prefix == NULL ||
	    strlen(name) < sizeof(HARD_PREFIX) ||
	    memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1) != 0
	   )
	    return orig_catopen(name, flag);

	// printf("path: %s prefix: %s %d\n", name, HARD_PREFIX, sizeof(HARD_PREFIX));
	// printf("memcmp %d\n", (memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1)));

	int prefix_len = strnlen(prefix, 256);
	memmove(buf, prefix, prefix_len);
	memmove(buf + prefix_len, name + sizeof(HARD_PREFIX), strlen(name) - sizeof(HARD_PREFIX));
	printf("catopen: changing path for %s (new path %s)\n", name, buf);
	return orig_catopen(buf, flag);
}


int __xstat64(int ver, const char * path, struct stat64 * stat_buf) {
	char buf[BUF_SIZE];
	const char * prefix = getenv("NIX_ZED_PREFIX");

	memset(buf, 0, BUF_SIZE);

    orig__xstat64_f_type orig_xstat64;
	orig_xstat64 = (orig__xstat64_f_type) dlsym(RTLD_NEXT, "__xstat64");

	if (prefix == NULL ||
	    strlen(path) < sizeof(HARD_PREFIX) ||
	    memcmp(path, HARD_PREFIX, sizeof(HARD_PREFIX) -1) != 0
	   )
		return orig_xstat64(ver, path, stat_buf);

	// printf("path: %s prefix: %s %d\n", name, HARD_PREFIX, sizeof(HARD_PREFIX));
	// printf("memcmp %d\n", (memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1)));

	int prefix_len = strnlen(prefix, 256);
	memmove(buf, prefix, prefix_len);
	memmove(buf + prefix_len, path + sizeof(HARD_PREFIX), strlen(path) - sizeof(HARD_PREFIX));
	printf("__xstat64: changing path for %s (new path %s)\n", path, buf);
	return orig_xstat64(ver, buf, stat_buf);
}
