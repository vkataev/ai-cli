#!/bin/sh
# Build the ai client. Override the compiler with CC, e.g. CC=clang ./run.build_ai.sh
# Extra flags may be appended via EXTRA_CFLAGS.
set -eu

CC="${CC:-gcc}"
CFLAGS="${CFLAGS:--std=c11 -O2 -Wall -Wextra -Wpedantic}"

# Expose the POSIX APIs the client relies on (getaddrinfo, termios, wcwidth,
# uname, TIOCGWINSZ, strncasecmp) under a strict -std=c11 build.
case "$(uname -s)" in
    MINGW64*)CC=/usr/bin/gcc ;;
    Linux*)  CFLAGS="$CFLAGS -D_GNU_SOURCE" ;;
    Darwin*) CFLAGS="$CFLAGS -D_DARWIN_C_SOURCE" ;;
esac

set -x
exec "$CC" $CFLAGS ${EXTRA_CFLAGS:-} ai.c -o ai
