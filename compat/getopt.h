#ifndef BITCRACKER_COMPAT_GETOPT_H
#define BITCRACKER_COMPAT_GETOPT_H

#ifdef _WIN32

#ifdef __cplusplus
extern "C" {
#endif

static char *optarg = 0;
static int optind = 1;
static int opterr = 1;
static int optopt = 0;

static __inline int getopt(int argc, char *const argv[], const char *optstring)
{
	static char *next = 0;
	const char *option = 0;

	if (next == 0 || *next == '\0') {
		if (optind >= argc || argv[optind][0] != '-' || argv[optind][1] == '\0') {
			return -1;
		}
		if (argv[optind][1] == '-' && argv[optind][2] == '\0') {
			optind++;
			return -1;
		}
		next = argv[optind] + 1;
	}

	optopt = *next++;
	option = optstring;
	while (*option != '\0' && *option != optopt) {
		option++;
	}

	if (*option == '\0') {
		if (*next == '\0') {
			optind++;
			next = 0;
		}
		return '?';
	}

	if (option[1] == ':') {
		if (*next != '\0') {
			optarg = next;
			optind++;
			next = 0;
		} else if (optind + 1 < argc) {
			optind++;
			optarg = argv[optind];
			optind++;
			next = 0;
		} else {
			if (opterr) {
				fprintf(stderr, "Option requires an argument: -%c\n", optopt);
			}
			optind++;
			next = 0;
			return '?';
		}
	} else if (*next == '\0') {
		optind++;
		next = 0;
	}

	return optopt;
}

#ifdef __cplusplus
}
#endif

#else
#include_next <getopt.h>
#endif

#endif
