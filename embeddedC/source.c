//#include <stdio.h>
//#include <stdint.h>
//#include "system.h"
//#include "io.h"
//#include "unistd.h"
//
//// ---------- Register map (word offsets) ----------
//#define AES_PT0   0x00
//#define AES_PT1   0x01
//#define AES_PT2   0x02
//#define AES_PT3   0x03
//
//#define AES_KEY0  0x04
//#define AES_KEY1  0x05
//#define AES_KEY2  0x06
//#define AES_KEY3  0x07
//
//#define AES_CTRL  0x0C   // bit0 = START, bit1 = DONE
//
//#define AES_OUT0  0x0D
//#define AES_OUT1  0x0E
//#define AES_OUT2  0x0F
//#define AES_OUT3  0x10
//
//static inline void aes_write(uint32_t offset, uint32_t data)
//{
//    IOWR(AES_0_BASE, offset, data);
//}
//
//static inline uint32_t aes_read(uint32_t offset)
//{
//    return IORD(AES_0_BASE, offset);
//}
//
//int main()
//{
//    uint32_t status;
//
//    printf("=== AES IP TEST START ===\n");
//
//    // -----------------------------
//    // Plaintext (LSW first)
//    // -----------------------------
//    uint32_t p0 = 0x00000000;
//    uint32_t p1 = 0x00000000;
//    uint32_t p2 = 0x00000000;
//    uint32_t p3 = 0x00000000;
//
//    aes_write(AES_PT0, p0);
//    aes_write(AES_PT1, p1);
//    aes_write(AES_PT2, p2);
//    aes_write(AES_PT3, p3);
//
//    // -----------------------------
//    // Key (LSW first)
//    // -----------------------------
//    uint32_t k0 = 0x00000000;
//    uint32_t k1 = 0x00000000;
//    uint32_t k2 = 0x00000000;
//    uint32_t k3 = 0x00000000;
//
//    aes_write(AES_KEY0, k0);
//    aes_write(AES_KEY1, k1);
//    aes_write(AES_KEY2, k2);
//    aes_write(AES_KEY3, k3);
//
//    // -----------------------------
//    // Start AES
//    // -----------------------------
//    aes_write(AES_CTRL, 0x1);
//    printf("AES started...\n");
//
//    // -----------------------------
//    // Poll DONE
//    // -----------------------------
//    do {
//        status = aes_read(AES_CTRL);
//    } while (((status >> 1) & 0x1) == 0);
//
//    printf("AES done!\n");
//
//    // -----------------------------
//    // Read ciphertext
//    // -----------------------------
//    uint32_t c0 = aes_read(AES_OUT0);
//    uint32_t c1 = aes_read(AES_OUT1);
//    uint32_t c2 = aes_read(AES_OUT2);
//    uint32_t c3 = aes_read(AES_OUT3);
//
//    printf("Ciphertext:\n");
//    printf("%08X %08X %08X %08X\n", c3, c2, c1, c0);
//
//    printf("=== AES IP TEST END ===\n");
//
//    while (1);
//}

//#include <stdio.h>
//#include <stdint.h>
//#include "system.h"
//#include "io.h"
//#include "unistd.h"
//
//// ================= Register offsets =================
//#define AES_PT0   0x00
//#define AES_PT1   0x01
//#define AES_PT2   0x02
//#define AES_PT3   0x03
//
//#define AES_KEY0  0x04
//#define AES_KEY1  0x05
//#define AES_KEY2  0x06
//#define AES_KEY3  0x07
//#define AES_KEY4  0x08
//#define AES_KEY5  0x09
//#define AES_KEY6  0x0A
//#define AES_KEY7  0x0B
//
//#define AES_CTRL  0x0C   // bit0 = START, bit1 = DONE
//
//#define AES_CT0   0x0D
//#define AES_CT1   0x0E
//#define AES_CT2   0x0F
//#define AES_CT3   0x10
//
//// ====================================================
//static inline void aes_write(uint32_t base, uint32_t off, uint32_t data)
//{
//    IOWR(base, off, data);
//}
//
//static inline uint32_t aes_read(uint32_t base, uint32_t off)
//{
//    return IORD(base, off);
//}
//
//// ====================================================
//void aes_run(
//    const char *name,
//    uint32_t base,
//    int key_words,          // 4 / 6 / 8
//    const uint32_t *pt,
//    const uint32_t *key
//)
//{
//    uint32_t status;
//    uint32_t ct[4];
//
//    printf("\n=== %s START ===\n", name);
//
//    // -------- Write plaintext (LSW first)
//    aes_write(base, AES_PT0, pt[0]);
//    aes_write(base, AES_PT1, pt[1]);
//    aes_write(base, AES_PT2, pt[2]);
//    aes_write(base, AES_PT3, pt[3]);
//
//    // -------- Write key
//    for (int i = 0; i < key_words; i++) {
//        aes_write(base, AES_KEY0 + i, key[i]);
//    }
//
//    // -------- Start
//    aes_write(base, AES_CTRL, 0x1);
//
//    // -------- Poll DONE
//    do {
//        status = aes_read(base, AES_CTRL);
//    } while (((status >> 1) & 0x1) == 0);
//
//    // -------- Read ciphertext
//    ct[0] = aes_read(base, AES_CT0);
//    ct[1] = aes_read(base, AES_CT1);
//    ct[2] = aes_read(base, AES_CT2);
//    ct[3] = aes_read(base, AES_CT3);
//
//    printf("%s Ciphertext = %08X %08X %08X %08X\n",
//           name, ct[3], ct[2], ct[1], ct[0]);
//}
//
//// ====================================================
//int main()
//{
//    printf("===== MULTI-AES IP TEST =====\n");
//
//    // ---------- Plaintext (FIPS-197)
//    uint32_t pt[4] = {
//        0xccddeeff,
//        0x8899aabb,
//        0x44556677,
//        0x00112233
//    };
//
//    // ---------- AES-128 key
//    uint32_t key128[4] = {
//        0x0c0d0e0f,
//        0x08090a0b,
//        0x04050607,
//        0x00010203
//    };
//
//    // ---------- AES-192 key
//    uint32_t key192[6] = {
//        0x14151617,
//        0x10111213,
//        0x0c0d0e0f,
//        0x08090a0b,
//        0x04050607,
//        0x00010203
//    };
//
//    // ---------- AES-256 key
//    uint32_t key256[8] = {
//        0x1c1d1e1f,
//        0x18191a1b,
//        0x14151617,
//        0x10111213,
//        0x0c0d0e0f,
//        0x08090a0b,
//        0x04050607,
//        0x00010203
//    };
//
//    // ---------- Run AES blocks
//    aes_run("AES-128", AES_0_BASE, 4, pt, key128);
//    aes_run("AES-192", AES_1_BASE, 6, pt, key192);
//    aes_run("AES-256", AES_2_BASE, 8, pt, key256);
//
//    printf("\n===== TEST DONE =====\n");
//
//    while (1);
//}

#include <stdio.h>
#include <stdint.h>

#include "system.h"
#include "aes.h"

// =====================================================
// Test vectors
// =====================================================
static const uint32_t plaintext[4] = {
    0x00112233,
    0x44556677,
    0x8899AABB,
    0xCCDDEEFF
};

static const uint32_t key_128[4] = {
    0x00010203, 0x04050607,
    0x08090A0B, 0x0C0D0E0F
};

static const uint32_t key_192[6] = {
    0x00010203, 0x04050607,
    0x08090A0B, 0x0C0D0E0F,
    0x10111213, 0x14151617
};

static const uint32_t key_256[8] = {
    0x00010203, 0x04050607,
    0x08090A0B, 0x0C0D0E0F,
    0x10111213, 0x14151617,
    0x18191A1B, 0x1C1D1E1F
};


// =====================================================
// Helper to print ciphertext
// =====================================================
static void print_ct(const char *label, const uint32_t *ct)
{
    printf("%s: %08X %08X %08X %08X\n",
           label, ct[3], ct[2], ct[1], ct[0]);
}

// =====================================================
// MAIN – Key Agility Demo
// =====================================================
int main(void)
{
    aes_dev_t aes;
    uint32_t ct[4];

    printf("=== AES KEY AGILITY DEMO ===\n\n");


    print_ct("PLAINTEXT", plaintext);

    // ---------------- AES-128 ----------------
    aes_init(&aes, AES_0_BASE, AES_KEY_128);
    aes_encrypt_block(&aes, plaintext, key_128, ct);
    print_ct("AES-128", ct);

    // ---------------- AES-192 ----------------
    aes_init(&aes, AES_1_BASE, AES_KEY_192);
    aes_encrypt_block(&aes, plaintext, key_192, ct);
    print_ct("AES-192", ct);

    // ---------------- AES-256 ----------------
    aes_init(&aes, AES_2_BASE, AES_KEY_256);
    aes_encrypt_block(&aes, plaintext, key_256, ct);
    print_ct("AES-256", ct);

    printf("\n=== DEMO DONE ===\n");

    while (1);
}


