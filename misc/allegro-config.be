#!/bin/sh
#
#  allegro-config script, BeOS version.
#
#  This script returns suitable commandline options for compiling programs
#  using the Allegro library, for example:
#
#     gcc myprog.c -o myprog `allegro-config --libs`
#
#  This is heavily based on the Unix version of this script.

version=3.9.38

prefix=/boot/develop
exec_prefix=$prefix
exec_prefix_set=no

lib_type=alleg

allegro_libs="-lbe -lgame -ldevice -lmidi -lmedia"
allegro_cflags=""

usage()
{
   cat <<EOF

Usage: allegro-config [OPTIONS] [LIBRARIES]

Options:
        --prefix[=DIR]
        --exec-prefix[=DIR]
        --version
        --cflags
        --libs

Libraries:
        release
        debug
        profile
EOF
   exit $1
}

if test $# -eq 0; then
   usage 1 1>&2
fi

while test $# -gt 0; do
   case "$1" in
   -*=*) optarg=`echo "$1" | sed 's/[-_a-zA-Z0-9]*=//'` ;;
   *) optarg= ;;
   esac

   case $1 in

      --prefix=*)
         prefix=$optarg
         if test $exec_prefix_set = no; then
            exec_prefix=$optarg
         fi
      ;;

      --prefix)
         echo_prefix=yes
      ;;

      --exec-prefix=*)
         exec_prefix=$optarg
         exec_prefix_set=yes
      ;;

      --exec-prefix)
         echo_exec_prefix=yes
      ;;

      --version)
         echo $version
      ;;

      --cflags)
         echo_cflags=yes
      ;;

      --libs)
         echo_libs=yes
      ;;

      release)
         lib_type=alleg
      ;;

      debug)
         allegro_cflags=-DDEBUGMODE $allegro_cflags
         lib_type=alld
      ;;

      profile)
         lib_type=allp
      ;;

      *)
         usage 1 1>&2
      ;;

   esac
   shift
done

if test "$echo_prefix" = "yes"; then
   echo $prefix
fi

if test "$echo_exec_prefix" = "yes"; then
   echo $exec_prefix
fi

if test "$echo_cflags" = "yes"; then
   echo -I${prefix}/headers/cpp $allegro_cflags
fi

if test "$echo_libs" = "yes"; then
   libdirs=-L${exec_prefix}/lib/x86
   echo $libdirs -l${lib_type} $allegro_libs
fi
