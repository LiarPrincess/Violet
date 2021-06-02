#include <assert.h>
#include <ctype.h>
#include <float.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// cSpell:ignore inity fdigits

// In CPython:
// Objects -> floatobject.c
// https://docs.python.org/3.7/c-api/float.html
// https://docs.python.org/3/library/stdtypes.html#float.fromhex <- THIS!

static int
Py_ISSPACE(const char s)
{
    return strncmp(&s, " ", 1) == 0;
}

static char
Py_TOLOWER(const char c)
{
    return tolower(c);
}

#define Py_HUGE_VAL HUGE_VAL

static int
case_insensitive_match(const char *s, const char *t)
{
    while (*t && Py_TOLOWER(*s) == *t)
    {
        s++;
        t++;
    }
    return *t ? 0 : 1;
}

static double
_Py_parse_inf_or_nan(const char *p, char **endptr)
{
    double retval;
    const char *s;
    int negate = 0;

    s = p;
    if (*s == '-')
    {
        negate = 1;
        s++;
    }
    else if (*s == '+')
    {
        s++;
    }

    if (case_insensitive_match(s, "inf"))
    {
        s += 3;
        if (case_insensitive_match(s, "inity"))
            s += 5;
        retval = negate ? -Py_HUGE_VAL : Py_HUGE_VAL;
    }
#ifdef Py_NAN
    else if (case_insensitive_match(s, "nan"))
    {
        s += 3;
        retval = negate ? -Py_NAN : Py_NAN;
    }
#endif
    else
    {
        s = p;
        retval = -1.0;
    }
    *endptr = (char *)s;
    return retval;
}

const char Py_hexdigits[16] = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

static char
char_from_hex(int x)
{
    assert(0 <= x && x < 16);
    return Py_hexdigits[x];
}

static int
hex_from_char(char c)
{
    int x;
    switch (c)
    {
    case '0':
        x = 0;
        break;
    case '1':
        x = 1;
        break;
    case '2':
        x = 2;
        break;
    case '3':
        x = 3;
        break;
    case '4':
        x = 4;
        break;
    case '5':
        x = 5;
        break;
    case '6':
        x = 6;
        break;
    case '7':
        x = 7;
        break;
    case '8':
        x = 8;
        break;
    case '9':
        x = 9;
        break;
    case 'a':
    case 'A':
        x = 10;
        break;
    case 'b':
    case 'B':
        x = 11;
        break;
    case 'c':
    case 'C':
        x = 12;
        break;
    case 'd':
    case 'D':
        x = 13;
        break;
    case 'e':
    case 'E':
        x = 14;
        break;
    case 'f':
    case 'F':
        x = 15;
        break;
    default:
        x = -1;
        break;
    }
    return x;
}

/* Minimum value between x and y */
#define Py_MIN(x, y) (((x) > (y)) ? (y) : (x))

/* Maximum value between x and y */
#define Py_MAX(x, y) (((x) > (y)) ? (x) : (y))

// static PyObject *
// float_fromhex(PyTypeObject *type, PyObject *string)
static void
float_fromhex(const char *s)
/*[clinic end generated code: output=46c0274d22b78e82 input=0407bebd354bca89]*/
{
    double x, result;
    long exp, top_exp, lsb, key_digit;
    const char *coeff_start, *s_store, *coeff_end, *exp_start, *s_end;
    int half_eps, digit, round_up, negate = 0;
    ssize_t length, ndigits, fdigits, i;

    /*
     * For the sake of simplicity and correctness, we impose an artificial
     * limit on ndigits, the total number of hex digits in the coefficient
     * The limit is chosen to ensure that, writing exp for the exponent,
     *
     *   (1) if exp > LONG_MAX/2 then the value of the hex string is
     *   guaranteed to overflow (provided it's nonzero)
     *
     *   (2) if exp < LONG_MIN/2 then the value of the hex string is
     *   guaranteed to underflow to 0.
     *
     *   (3) if LONG_MIN/2 <= exp <= LONG_MAX/2 then there's no danger of
     *   overflow in the calculation of exp and top_exp below.
     *
     * More specifically, ndigits is assumed to satisfy the following
     * inequalities:
     *
     *   4*ndigits <= DBL_MIN_EXP - DBL_MANT_DIG - LONG_MIN/2
     *   4*ndigits <= LONG_MAX/2 + 1 - DBL_MAX_EXP
     *
     * If either of these inequalities is not satisfied, a ValueError is
     * raised.  Otherwise, write x for the value of the hex string, and
     * assume x is nonzero.  Then
     *
     *   2**(exp-4*ndigits) <= |x| < 2**(exp+4*ndigits).
     *
     * Now if exp > LONG_MAX/2 then:
     *
     *   exp - 4*ndigits >= LONG_MAX/2 + 1 - (LONG_MAX/2 + 1 - DBL_MAX_EXP)
     *                    = DBL_MAX_EXP
     *
     * so |x| >= 2**DBL_MAX_EXP, which is too large to be stored in C
     * double, so overflows.  If exp < LONG_MIN/2, then
     *
     *   exp + 4*ndigits <= LONG_MIN/2 - 1 + (
     *                      DBL_MIN_EXP - DBL_MANT_DIG - LONG_MIN/2)
     *                    = DBL_MIN_EXP - DBL_MANT_DIG - 1
     *
     * and so |x| < 2**(DBL_MIN_EXP-DBL_MANT_DIG-1), hence underflows to 0
     * when converted to a C double.
     *
     * It's easy to show that if LONG_MIN/2 <= exp <= LONG_MAX/2 then both
     * exp+4*ndigits and exp-4*ndigits are within the range of a long.
     */

    if (s == NULL)
        return;

    length = strlen(s);
    s_end = s + length;

    /********************
     * Parse the string *
     ********************/

    /* leading whitespace */
    while (Py_ISSPACE(*s))
        s++;

    printf("Starting with: '%s'\n", s);

    /* infinities and nans */
    x = _Py_parse_inf_or_nan(s, (char **)&coeff_end);
    if (coeff_end != s)
    {
        s = coeff_end;
        goto finished;
    }

    /* optional sign */
    if (*s == '-')
    {
        s++;
        negate = 1;
    }
    else if (*s == '+')
        s++;

    printf("negate: %d\n", negate);

    /* [0x] */
    s_store = s;
    if (*s == '0')
    {
        s++;
        if (*s == 'x' || *s == 'X')
        {
            printf("Consuming '0x'\n");
            s++;
        }
        else
            s = s_store;
    }

    /* coefficient: <integer> [. <fraction>] */
    coeff_start = s;
    while (hex_from_char(*s) >= 0)
        s++;
    s_store = s;
    if (*s == '.')
    {
        s++;
        while (hex_from_char(*s) >= 0)
            s++;
        coeff_end = s - 1;
    }
    else
        coeff_end = s;

    /* ndigits = total # of hex digits; fdigits = # after point */
    ndigits = coeff_end - coeff_start;
    fdigits = coeff_end - s_store;

    printf("ndigits: %zd\n", ndigits);
    printf("fdigits: %zd\n", fdigits);

    if (ndigits == 0)
    {
        printf("Error: ndigits == 0\n");
        goto parse_error;
    }

    if (ndigits > Py_MIN(DBL_MIN_EXP - DBL_MANT_DIG - LONG_MIN / 2, LONG_MAX / 2 + 1 - DBL_MAX_EXP) / 4)
    {
        printf("Error: insane_length_error\n");
        goto insane_length_error;
    }

    /* [p <exponent>] */
    if (*s == 'p' || *s == 'P')
    {
        s++;
        exp_start = s;
        if (*s == '-' || *s == '+')
            s++;
        if (!('0' <= *s && *s <= '9'))
            goto parse_error;
        s++;
        while ('0' <= *s && *s <= '9')
            s++;
        exp = strtol(exp_start, NULL, 10);
    }
    else
        exp = 0;

    printf("exp: %zd\n", exp);
    printf("=== Separator with a lot of stars ===\n");

    /*******************************************
     * Compute rounded value of the hex string *
     *******************************************/

/* for 0 <= j < ndigits, HEX_DIGIT(j) gives the jth most significant digit */
#define HEX_DIGIT(j) hex_from_char(*((j) < fdigits ? coeff_end - (j) : coeff_end - 1 - (j)))

    /* Discard leading zeros, and catch extreme overflow and underflow */
    while (ndigits > 0 && HEX_DIGIT(ndigits - 1) == 0)
    {
        printf("Removing leading zero");
        ndigits--;
    }

    if (ndigits == 0 || exp < LONG_MIN / 2)
    {
        printf("ndigits == 0 || exp < LONG_MIN/2");
        x = 0.0;
        goto finished;
    }
    if (exp > LONG_MAX / 2)
    {
        printf("exp > LONG_MAX/2");
        goto overflow_error;
    }

    /* Adjust exponent for fractional part. */
    exp = exp - 4 * ((long)fdigits);
    printf("changing exponent to: %zd\n", exp);

    /* top_exp = 1 more than exponent of most sig. bit of coefficient */
    top_exp = exp + 4 * ((long)ndigits - 1);
    printf("Initial top_exp: %zd\n", top_exp);
    for (digit = HEX_DIGIT(ndigits - 1); digit != 0; digit /= 2)
    {
        top_exp++;
        printf("Incrementing topExp: %zd, digit: %d\n", top_exp, digit);
    }

    /* catch almost all nonextreme cases of overflow and underflow here */
    if (top_exp < DBL_MIN_EXP - DBL_MANT_DIG)
    {
        printf("top_exp < DBL_MIN_EXP - DBL_MANT_DIG\n");
        x = 0.0;
        goto finished;
    }
    if (top_exp > DBL_MAX_EXP)
    {
        printf("top_exp > DBL_MAX_EXP\n");
        goto overflow_error;
    }

    /* lsb = exponent of least significant bit of the *rounded* value.
       This is top_exp - DBL_MANT_DIG unless result is subnormal. */
    lsb = Py_MAX(top_exp, (long)DBL_MIN_EXP) - DBL_MANT_DIG;
    printf("lsb: %ld\n", lsb);

    x = 0.0;
    if (exp >= lsb)
    {
        /* no rounding required */
        printf("exp >= lsb\n");
        for (i = ndigits - 1; i >= 0; i--)
        {
            printf("  iter %zd, value %f\n", i, x);
            x = 16.0 * x + HEX_DIGIT(i);
        }

        printf("ldexp(%f, %ld)\n", x, exp);
        x = ldexp(x, (int)(exp));
        goto finished;
    }

    /* rounding required.  key_digit is the index of the hex digit
       containing the first bit to be rounded away. */
    half_eps = 1 << (int)((lsb - exp - 1) % 4);
    key_digit = (lsb - exp - 1) / 4;
    printf("half_eps: %d\n", half_eps);
    printf("key_digit: %ld\n", key_digit);

    for (i = ndigits - 1; i > key_digit; i--)
        x = 16.0 * x + HEX_DIGIT(i);

    digit = HEX_DIGIT(key_digit);
    x = 16.0 * x + (double)(digit & (16 - 2 * half_eps));

    /* round-half-even: round up if bit lsb-1 is 1 and at least one of
       bits lsb, lsb-2, lsb-3, lsb-4, ... is 1. */
    if ((digit & half_eps) != 0)
    {
        round_up = 0;
        if ((digit & (3 * half_eps - 1)) != 0 ||
            (half_eps == 8 && (HEX_DIGIT(key_digit + 1) & 1) != 0))
            round_up = 1;
        else
            for (i = key_digit - 1; i >= 0; i--)
                if (HEX_DIGIT(i) != 0)
                {
                    round_up = 1;
                    break;
                }
        if (round_up)
        {
            x += 2 * half_eps;
            if (top_exp == DBL_MAX_EXP &&
                x == ldexp((double)(2 * half_eps), DBL_MANT_DIG))
                /* overflow corner case: pre-rounded value <
                   2**DBL_MAX_EXP; rounded=2**DBL_MAX_EXP. */
                goto overflow_error;
        }
    }
    x = ldexp(x, (int)(exp + 4 * key_digit));

finished:
    /* optional trailing whitespace leading to the end of the string */
    while (Py_ISSPACE(*s))
        s++;

    if (s != s_end)
        goto parse_error;

    result = negate ? -x : x;
    printf("Result:   %f\n", result);
    return;

overflow_error:
    printf("PyExc_OverflowError: hexadecimal value too large to represent as a float\n");
    return;

parse_error:
    printf("PyExc_ValueError: invalid hexadecimal floating-point string\n");
    return;

insane_length_error:
    printf("PyExc_ValueError: hexadecimal string too long to convert\n");
    return;
}

int main()
{
    // From https://docs.python.org/3/library/stdtypes.html#float.fromhex:
    // For example, the hexadecimal string 0x3.a7p10
    // represents the floating-point number (3 + 10./16 + 7./16**2) * 2.0**10, or 3740.0:
    float_fromhex("0x3.a7p10");
    printf("Expected: 3740.0\n");
    return 0;
}
