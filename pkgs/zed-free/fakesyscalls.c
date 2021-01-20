//#include <sys/types.h>
//#include <sys/stat.h>
//#include <fcntl.h>
#include <stdio.h>
#include <string.h>

#define _GNU_SOURCE
#include <dlfcn.h>

#define BUF_SIZE 256
#define HARD_PREFIX "/usr/share"

typedef FILE * (* orig_fopen64_f_type)(const char *filename, const char *type);

typedef int (* orig__openat64_2_f_type) (int dirfd, const char *path, int flags);

typedef int (*orig_openat_f_type) (int fd, const char * path, int oflag);

typedef int (*orig_openat64_f_type) (int fd, const char * path, int oflag);

#include <nl_types.h>
#include <stdlib.h>

typedef nl_catd (*orig_catopen_f_type)(const char *pathname, int flags);

#include <sys/stat.h>
#include <unistd.h>
typedef int (*orig__xstat64_f_type) (int ver, const char * path, struct stat64 * stat_buf);


FILE *fopen64(const char *filename, const char *type) {
	char buf[BUF_SIZE];
	const char * prefix = getenv("NIX_ZED_PREFIX");

	memset(buf, 0, BUF_SIZE);

	orig_fopen64_f_type orig_fopen64;
	orig_fopen64 = (orig_fopen64_f_type)dlsym(RTLD_NEXT,"fopen64");

	if (prefix == NULL ||
	    strlen(filename) < sizeof(HARD_PREFIX) ||
	    memcmp(filename, HARD_PREFIX, sizeof(HARD_PREFIX) -1) != 0
	   )
		return orig_fopen64(filename, type);

	// printf("path: %s prefix: %s %d\n", name, HARD_PREFIX, sizeof(HARD_PREFIX));
	// printf("memcmp %d\n", (memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1)));

	int prefix_len = strnlen(prefix, 256);
	memmove(buf, prefix, prefix_len);
	memmove(buf + prefix_len, filename + sizeof(HARD_PREFIX), strlen(filename) - sizeof(HARD_PREFIX));
	printf("fopen64: changing path for %s (new path %s)\n", filename, buf);

	return orig_fopen64(buf, type);
}



int __openat64_2(int dirfd, const char *path, int flags) {
	char buf[BUF_SIZE];
	const char * prefix = getenv("NIX_ZED_PREFIX");

	memset(buf, 0, BUF_SIZE);

	orig__openat64_2_f_type orig__openat64_2;
	orig__openat64_2 = (orig__openat64_2_f_type)dlsym(RTLD_NEXT, "__openat64_2");

	if (prefix == NULL ||
	    strlen(path) < sizeof(HARD_PREFIX) ||
	    memcmp(path, HARD_PREFIX, sizeof(HARD_PREFIX) -1) != 0
	   )
		return orig__openat64_2(dirfd, path, flags);

	// printf("path: %s prefix: %s %d\n", name, HARD_PREFIX, sizeof(HARD_PREFIX));
	// printf("memcmp %d\n", (memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1)));

	int prefix_len = strnlen(prefix, 256);
	memmove(buf, prefix, prefix_len);
	memmove(buf + prefix_len, path + sizeof(HARD_PREFIX), strlen(path) - sizeof(HARD_PREFIX));
	printf("__openat64_2: changing path for %s (new path %s)\n", path, buf);

	return orig__openat64_2(dirfd, path, flags);
}


int openat64 (int fd, const char * path, int oflag) {
	char buf[BUF_SIZE];
	const char * prefix = getenv("NIX_ZED_PREFIX");

	memset(buf, 0, BUF_SIZE);

	orig_openat64_f_type orig_openat64;
    orig_openat64 = (orig_openat64_f_type)dlsym(RTLD_NEXT, "openat64");

	if (prefix == NULL ||
	    strlen(path) < sizeof(HARD_PREFIX) ||
	    memcmp(path, HARD_PREFIX, sizeof(HARD_PREFIX) -1) != 0
	   )
		return orig_openat64(fd, path, oflag);

	// printf("path: %s prefix: %s %d\n", name, HARD_PREFIX, sizeof(HARD_PREFIX));
	// printf("memcmp %d\n", (memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1)));

	int prefix_len = strnlen(prefix, 256);
	memmove(buf, prefix, prefix_len);
	memmove(buf + prefix_len, path + sizeof(HARD_PREFIX), strlen(path) - sizeof(HARD_PREFIX));
	printf("openat64: changing path for %s (new path %s)\n", path, buf);

	return orig_openat64(fd, path, oflag);
}

int openat(int fd, const char * path, int oflag) {
	char buf[BUF_SIZE];
	const char * prefix = getenv("NIX_ZED_PREFIX");

	memset(buf, 0, BUF_SIZE);

	orig_openat_f_type orig_openat;
    orig_openat = (orig_openat_f_type)dlsym(RTLD_NEXT, "openat");

	if (prefix == NULL ||
	    strlen(path) < sizeof(HARD_PREFIX) ||
	    memcmp(path, HARD_PREFIX, sizeof(HARD_PREFIX) -1) != 0
	   )
		return orig_openat(fd, path, oflag);

	// printf("path: %s prefix: %s %d\n", name, HARD_PREFIX, sizeof(HARD_PREFIX));
	// printf("memcmp %d\n", (memcmp(name, HARD_PREFIX, sizeof(HARD_PREFIX) -1)));

	int prefix_len = strnlen(prefix, 256);
	memmove(buf, prefix, prefix_len);
	memmove(buf + prefix_len, path + sizeof(HARD_PREFIX), strlen(path) - sizeof(HARD_PREFIX));
	printf("openat: changing path for %s (new path %s)\n", path, buf);

	return orig_openat(fd, path, oflag);
}

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
