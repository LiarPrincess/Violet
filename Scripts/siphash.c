// Generate test code for out SipHash implementation.
// We will use 'I See the Light' lyrics from:
// https://genius.com/Walt-disney-records-i-see-the-light-lyrics

#include <assert.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

int siphash(const uint8_t *in, const size_t inlen,
            const uint8_t *k,
            uint8_t *out, const size_t outlen);

// Key is 'I See the Light ' in ASCII
const uint64_t k[] = { 0x4920536565207468, 0x65204c6967687420 };

uint64_t siphash_str(const char* str) {
    uint8_t *in = (uint8_t *) str;
    size_t inlen = strlen(str);

    uint64_t out = 0;
    size_t outlen = 8;

    int err = siphash(in, inlen, (uint8_t *) k, (uint8_t *) &out, outlen);
    assert(err == 0);

    return out;
}

const char *lyrics[] = {
    "All those days watching from the windows",
    "All those years outside looking in",
    "All that time never even knowing",
    "Just how blind I've been",
    "Now I'm here blinking in the starlight",
    "Now I'm here suddenly I see",
    "Standing here it's all so clear",
    "I'm where I'm meant to be",
    "",
    "And at last I see the light",
    "And it's like the fog has lifted",
    "And at last I see the light",
    "And it's like the sky is new",
    "And it's warm and real and bright",
    "And the world has somehow shifted",
    "All at once everything looks different",
    "Now that I see you",
    "",
    "[FLYNN]",
    "All those days chasing down a daydream",
    "All those years living in a blur",
    "All that time never truly seeing",
    "Things, the way they were",
    "Now she's here shining in the starlight",
    "Now she's here suddenly I know",
    "If she's here it's crystal clear",
    "I'm where I'm meant to go",
    "",
    "[FLYNN & RAPUNZEL]",
    "And at last I see the light",
    "",
    "[FLYNN]",
    "And it's like the fog has lifted",
    "",
    "[FLYNN & RAPUNZEL]",
    "And at last I see the light",
    "",
    "[RAPUNZEL]",
    "And it's like the sky is new",
    "",
    "[FLYNN & RAPUNZEL]",
    "And it's warm and real and bright",
    "And the world has somehow shifted",
    "All at once everything is different",
    "Now that I see you",
    "",
    "Now that I see you",
};

// Example from paper (https://131002.net/siphash/siphash.pdf).
void paper_example() {
    uint8_t in[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 };
    size_t inlen = 15;

    const uint64_t k[] = { 0x0706050403020100, 0x0f0e0d0c0b0a0908 };

    uint64_t out = 0;
    size_t outlen = 8;

    int err = siphash(in, inlen, (uint8_t *) k, (uint8_t *) &out, outlen);
    assert(err == 0);

    const uint64_t expected = 0xa129ca6149be45e5;
    printf("Expected: %llu\n", expected);
    printf("Result:   %llu\n", out);
}

int main()
{
    size_t lyricsCount = sizeof(lyrics)/sizeof(lyrics[0]);
    for (int i = 0; i < lyricsCount; ++i)
    {
        const char *line = lyrics[i];
        int isEmpty = strncmp(line, "", 2) == 0;

        if (!isEmpty) {
            uint64_t hash = siphash_str(line);
            printf("XCTAssertEqual(self.hash(\"%s\"), %llu)\n", line, hash);
        } else {
            printf("\n");
        }
    }

    // paper_example();

    return 0;
}

/*
   SipHash reference C implementation

   Copyright (c) 2012-2016 Jean-Philippe Aumasson
   <jeanphilippe.aumasson@gmail.com>
   Copyright (c) 2012-2014 Daniel J. Bernstein <djb@cr.yp.to>

   To the extent possible under law, the author(s) have dedicated all copyright
   and related and neighboring rights to this software to the public domain
   worldwide. This software is distributed without any warranty.

   You should have received a copy of the CC0 Public Domain Dedication along
   with
   this software. If not, see
   <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
#include <assert.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* default: SipHash-2-4 */
#ifndef cROUNDS
    #define cROUNDS 2
#endif
#ifndef dROUNDS
    #define dROUNDS 4
#endif

#define ROTL(x, b) (uint64_t)(((x) << (b)) | ((x) >> (64 - (b))))

#define U32TO8_LE(p, v)                                                        \
    (p)[0] = (uint8_t)((v));                                                   \
    (p)[1] = (uint8_t)((v) >> 8);                                              \
    (p)[2] = (uint8_t)((v) >> 16);                                             \
    (p)[3] = (uint8_t)((v) >> 24);

#define U64TO8_LE(p, v)                                                        \
    U32TO8_LE((p), (uint32_t)((v)));                                           \
    U32TO8_LE((p) + 4, (uint32_t)((v) >> 32));

#define U8TO64_LE(p)                                                           \
    (((uint64_t)((p)[0])) | ((uint64_t)((p)[1]) << 8) |                        \
     ((uint64_t)((p)[2]) << 16) | ((uint64_t)((p)[3]) << 24) |                 \
     ((uint64_t)((p)[4]) << 32) | ((uint64_t)((p)[5]) << 40) |                 \
     ((uint64_t)((p)[6]) << 48) | ((uint64_t)((p)[7]) << 56))

#define SIPROUND                                                               \
    do {                                                                       \
        v0 += v1;                                                              \
        v1 = ROTL(v1, 13);                                                     \
        v1 ^= v0;                                                              \
        v0 = ROTL(v0, 32);                                                     \
        v2 += v3;                                                              \
        v3 = ROTL(v3, 16);                                                     \
        v3 ^= v2;                                                              \
        v0 += v3;                                                              \
        v3 = ROTL(v3, 21);                                                     \
        v3 ^= v0;                                                              \
        v2 += v1;                                                              \
        v1 = ROTL(v1, 17);                                                     \
        v1 ^= v2;                                                              \
        v2 = ROTL(v2, 32);                                                     \
    } while (0)

#ifdef DEBUG
#define TRACE                                                                  \
    do {                                                                       \
        printf("(%3zu) v0 %016"PRIx64"\n", inlen, v0);                         \
        printf("(%3zu) v1 %016"PRIx64"\n", inlen, v1);                         \
        printf("(%3zu) v2 %016"PRIx64"\n", inlen, v2);                         \
        printf("(%3zu) v3 %016"PRIx64"\n", inlen, v3);                         \
    } while (0)
#else
#define TRACE
#endif

int siphash(const uint8_t *in, const size_t inlen, const uint8_t *k,
            uint8_t *out, const size_t outlen) {

    assert((outlen == 8) || (outlen == 16));
    uint64_t v0 = UINT64_C(0x736f6d6570736575);
    uint64_t v1 = UINT64_C(0x646f72616e646f6d);
    uint64_t v2 = UINT64_C(0x6c7967656e657261);
    uint64_t v3 = UINT64_C(0x7465646279746573);
    uint64_t k0 = U8TO64_LE(k);
    uint64_t k1 = U8TO64_LE(k + 8);
    uint64_t m;
    int i;
    const uint8_t *end = in + inlen - (inlen % sizeof(uint64_t));
    const int left = inlen & 7;
    uint64_t b = ((uint64_t)inlen) << 56;
    v3 ^= k1;
    v2 ^= k0;
    v1 ^= k1;
    v0 ^= k0;

    if (outlen == 16)
        v1 ^= 0xee;

    for (; in != end; in += 8) {
        m = U8TO64_LE(in);
        v3 ^= m;

        TRACE;
        for (i = 0; i < cROUNDS; ++i)
            SIPROUND;

        v0 ^= m;
    }

    switch (left) {
    case 7:
        b |= ((uint64_t)in[6]) << 48;
    case 6:
        b |= ((uint64_t)in[5]) << 40;
    case 5:
        b |= ((uint64_t)in[4]) << 32;
    case 4:
        b |= ((uint64_t)in[3]) << 24;
    case 3:
        b |= ((uint64_t)in[2]) << 16;
    case 2:
        b |= ((uint64_t)in[1]) << 8;
    case 1:
        b |= ((uint64_t)in[0]);
        break;
    case 0:
        break;
    }

    v3 ^= b;

    TRACE;
    for (i = 0; i < cROUNDS; ++i)
        SIPROUND;

    v0 ^= b;

    if (outlen == 16)
        v2 ^= 0xee;
    else
        v2 ^= 0xff;

    TRACE;
    for (i = 0; i < dROUNDS; ++i)
        SIPROUND;

    b = v0 ^ v1 ^ v2 ^ v3;
    U64TO8_LE(out, b);

    if (outlen == 8)
        return 0;

    v1 ^= 0xdd;

    TRACE;
    for (i = 0; i < dROUNDS; ++i)
        SIPROUND;

    b = v0 ^ v1 ^ v2 ^ v3;
    U64TO8_LE(out + 8, b);

    return 0;
}
