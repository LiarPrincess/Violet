#include "./siphash.c"

// Key is 'I See the Light ' in ASCII
const uint64_t key[] = {0x4920536565207468, 0x65204c6967687420};

uint64_t siphash_str(const char *str)
{
    uint8_t *in = (uint8_t *)str;
    size_t inlen = strlen(str);

    uint64_t out = 0;
    size_t outlen = 8;

    int err = siphash(in, inlen, (uint8_t *)key, (uint8_t *)&out, outlen);
    assert(err == 0);

    return out;
}

const char *lyrics[] = {
    "[RAPUNZEL]",
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
void paper_example()
{
    uint8_t in[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14};
    size_t inlen = 15;

    const uint64_t k[] = {0x0706050403020100, 0x0f0e0d0c0b0a0908};

    uint64_t out = 0;
    size_t outlen = 8;

    int err = siphash(in, inlen, (uint8_t *)k, (uint8_t *)&out, outlen);
    assert(err == 0);

    const uint64_t expected = 0xa129ca6149be45e5;
    printf("Expected: %llu\n", expected);
    printf("Result:   %llu\n", out);
}

int main()
{
    // paper_example();

    size_t lyricsCount = sizeof(lyrics) / sizeof(lyrics[0]);
    for (int i = 0; i < lyricsCount; ++i)
    {
        const char *line = lyrics[i];
        int isEmpty = strncmp(line, "", 2) == 0;

        if (!isEmpty)
        {
            uint64_t hash = siphash_str(line);
            printf("XCTAssertEqual(self.hash(\"%s\"), %llu)\n", line, hash);
        }
        else
        {
            printf("\n");
        }
    }

    return 0;
}
