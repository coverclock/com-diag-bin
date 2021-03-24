/* vi: set ts=4 expandtab shiftwidth=4: */
/**
 * @file
 * @copyright Copyright 2021 Digital Aggregates Corporation, Colorado, USA.
 * @note Licensed under the terms in LICENSE.txt.
 * @brief XXXXXXXX
 * @author Chip Overclock <mailto:coverclock@diag.com>
 * @see XXXXXXXX <https://github.com/coverclock/com-diag-XXXXXXXX>
 * @details
 *
 * ABSTRACT
 *
 * XXXXXXXX
 *
 * USAGE
 *
 * XXXXXXXX
 *
 * EXAMPLES
 *
 * XXXXXXXX
 */

#include "com/diag/XXXXXXXX/XXXXXXXX_XXXXXXXX.h"
#include <string.h>
#include <unistd.h>
#include "../src/XXXXXXXX_XXXXXXXX.h"
#include "XXXXXXXX.h"

static const char * Program = (const char *)0;

int main(int argc, char * argv[])
{
    int error = 0;
    char * end = (char *)0;
    extern char * optarg;
    extern int optind;
    extern int opterr;
    extern int optopt;
    /*
     * Command line options.
     */
    static const char OPTIONS[] = "1278B:C:D:EFG:H:I:KL:MN:O:PRS:T:U:VW:XY:b:cdeg:hk:lmnop:st:uvxy:?";

    Program = ((Program = strrchr(argv[0], '/')) == (char *)0) ? argv[0] : Program + 1;


    /*
     * OPTIONS
     */

    while ((opt = getopt(argc, argv, OPTIONS)) >= 0) {
        switch (opt) {
        case '1':
            stopbits = 1;
            serial = !0;
            break;
        case '?':
        default:
            fprintf(stderr, "usage: %s"
                           " [ -X XXXXXXXX ]"
                          "\n", Program);
            fprintf(stderr, "       -X XXXXXXXX XXXXXXXX.\n");
            break;
        }
    }

}
