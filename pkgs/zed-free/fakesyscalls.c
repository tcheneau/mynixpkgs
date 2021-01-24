#include <stdio.h>
#include <string.h>

/* good tutorials on LD_PRELOAD
   http://www.goldsborough.me/c/low-level/kernel/2016/08/29/16-48-53-the_-ld_preload-_trick/
   https://rafalcieslak.wordpress.com/2013/04/02/dynamic-linker-tricks-using-ld_preload-to-cheat-inject-features-and-investigate-programs/
 */

// variable arguments
#include <stdarg.h>


#define _GNU_SOURCE
#include <dlfcn.h>

#define BUF_SIZE 256
#define HARD_USR_PREFIX "/usr/share"
#define HARD_ETC_PREFIX "/etc/primx"

typedef FILE * (* orig_fopen64_f_type)(const char *filename, const char *type);

typedef int (* orig__openat64_2_f_type) (int dirfd, const char *path, int flags);

typedef int (*orig_openat_f_type) (int fd, const char * path, int oflag);

typedef int (*orig_openat64_f_type) (int fd, const char * path, int oflag, ...);

#include <nl_types.h>
#include <stdlib.h>

typedef nl_catd (*orig_catopen_f_type)(const char *pathname, int flags);

#include <sys/stat.h>
#include <unistd.h>
typedef int (*orig__xstat64_f_type) (int ver, const char * path, struct stat64 * stat_buf);

#define INIT_MATCH_AND_REPLACE(STRING) \
char buf[BUF_SIZE]; \
memset(buf, 0, BUF_SIZE); \
const char * new_prefix = NULL; \
memcpy(buf, STRING, strlen(STRING)) 


#define MATCH_AND_REPLACE(STRING, FUNCNAME, PREFIX, ENVPREFIX) do { \
	new_prefix = getenv(ENVPREFIX); \
	if (new_prefix != NULL && \
	    strlen(STRING) > sizeof(PREFIX) && \
	    memcmp(STRING, PREFIX, sizeof(PREFIX) -1) == 0 \
	   ) { \
	       int new_prefix_len = strnlen(new_prefix, 256); \
	       memmove(buf, new_prefix, new_prefix_len); \
	       memmove(buf + new_prefix_len, STRING + sizeof(PREFIX), strlen(STRING) - sizeof(PREFIX));  \
	       printf(FUNCNAME ": changing path for %s (new path %s)\n", STRING, buf); \
	   } \
} while (0)

FILE *fopen64(const char *filename, const char *type) {
	INIT_MATCH_AND_REPLACE(filename);

	orig_fopen64_f_type orig_fopen64;
	orig_fopen64 = (orig_fopen64_f_type)dlsym(RTLD_NEXT,"fopen64");

	MATCH_AND_REPLACE(filename, "fopen64", HARD_USR_PREFIX, "NIX_ZED_USR_PREFIX");
	MATCH_AND_REPLACE(filename, "fopen64", HARD_ETC_PREFIX, "NIX_ZED_ETC_PREFIX");

	return orig_fopen64(buf, type);
}



int __openat64_2(int dirfd, const char *path, int flags) {
	INIT_MATCH_AND_REPLACE(path);

	orig__openat64_2_f_type orig__openat64_2;
	orig__openat64_2 = (orig__openat64_2_f_type)dlsym(RTLD_NEXT, "__openat64_2");

	MATCH_AND_REPLACE(path, "__openat64_2", HARD_USR_PREFIX, "NIX_ZED_USR_PREFIX");
	MATCH_AND_REPLACE(path, "__openat64_2", HARD_ETC_PREFIX, "NIX_ZED_ETC_PREFIX");

	return orig__openat64_2(dirfd, buf, flags);
}

int openat64 (int fd, const char * path, int oflag, ...) {
	INIT_MATCH_AND_REPLACE(path);

	int mode = 0;

	va_list arg;
    va_start (arg, oflag);
    mode = va_arg (arg, int);
    va_end (arg);

	orig_openat64_f_type orig_openat64;
    orig_openat64 = (orig_openat64_f_type)dlsym(RTLD_NEXT, "openat64");

	MATCH_AND_REPLACE(path, "openat64", HARD_USR_PREFIX, "NIX_ZED_USR_PREFIX");
	MATCH_AND_REPLACE(path, "openat64", HARD_ETC_PREFIX, "NIX_ZED_ETC_PREFIX");

	return orig_openat64(fd, buf, oflag, mode);
}

int openat(int fd, const char * path, int oflag) {
	INIT_MATCH_AND_REPLACE(path);

	orig_openat_f_type orig_openat;
    orig_openat = (orig_openat_f_type)dlsym(RTLD_NEXT, "openat");

	MATCH_AND_REPLACE(path, "openat", HARD_USR_PREFIX, "NIX_ZED_USR_PREFIX");
	MATCH_AND_REPLACE(path, "openat", HARD_ETC_PREFIX, "NIX_ZED_ETC_PREFIX");

	return orig_openat(fd, buf, oflag);
}

nl_catd catopen(const char *name, int flag) {
	INIT_MATCH_AND_REPLACE(name);

	orig_catopen_f_type orig_catopen;
    orig_catopen = (orig_catopen_f_type)dlsym(RTLD_NEXT,"catopen");

	MATCH_AND_REPLACE(name, "catopen", HARD_USR_PREFIX, "NIX_ZED_USR_PREFIX");
	MATCH_AND_REPLACE(name, "catopen", HARD_ETC_PREFIX, "NIX_ZED_ETC_PREFIX");

	return orig_catopen(buf, flag);
}

int __xstat64(int ver, const char * path, struct stat64 * stat_buf) {
	INIT_MATCH_AND_REPLACE(path);

    orig__xstat64_f_type orig_xstat64;
	orig_xstat64 = (orig__xstat64_f_type) dlsym(RTLD_NEXT, "__xstat64");

	MATCH_AND_REPLACE(path, "__xstat64", HARD_USR_PREFIX, "NIX_ZED_USR_PREFIX");
	MATCH_AND_REPLACE(path, "__xstat64", HARD_ETC_PREFIX, "NIX_ZED_ETC_PREFIX");

	return orig_xstat64(ver, buf, stat_buf);
}
