/*
 * aes.c
 *
 *  Created on: Dec 19, 2025
 *      Author: AD
 */
#include "aes.h"
#include "io.h"

// =====================================================
// AES register offsets (word offsets)
// =====================================================
#define AES_PT0   0x00
#define AES_PT1   0x01
#define AES_PT2   0x02
#define AES_PT3   0x03

#define AES_KEY0  0x04

#define AES_CTRL  0x0C   // bit0 = START, bit1 = DONE

#define AES_CT0   0x0D
#define AES_CT1   0x0E
#define AES_CT2   0x0F
#define AES_CT3   0x10

// =====================================================
// Low-level register access (PRIVATE)
// =====================================================
static inline void aes_write(uint32_t base,
                             uint32_t offset,
                             uint32_t data)
{
    IOWR(base, offset, data);
}

static inline uint32_t aes_read(uint32_t base,
                                uint32_t offset)
{
    return IORD(base, offset);
}

// =====================================================
// Driver API implementation
// =====================================================

void aes_init(aes_dev_t *dev,
              uint32_t base,
              aes_key_size_t key_size)
{
    dev->base = base;
    dev->key_words = key_size;
}

void aes_set_plaintext(aes_dev_t *dev,
                       const uint32_t *pt)
{
    aes_write(dev->base, AES_PT0, pt[0]);
    aes_write(dev->base, AES_PT1, pt[1]);
    aes_write(dev->base, AES_PT2, pt[2]);
    aes_write(dev->base, AES_PT3, pt[3]);
}

void aes_set_key(aes_dev_t *dev,
                 const uint32_t *key)
{
    for (int i = 0; i < dev->key_words; i++) {
        aes_write(dev->base, AES_KEY0 + i, key[i]);
    }
}

void aes_start(aes_dev_t *dev)
{
    // Write START bit (bit0 = 1)
    aes_write(dev->base, AES_CTRL, 0x1);
}

void aes_wait_done(aes_dev_t *dev)
{
    uint32_t status;

    // Poll DONE bit (bit1)
    do {
        status = aes_read(dev->base, AES_CTRL);
    } while (((status >> 1) & 0x1) == 0);
}

void aes_get_ciphertext(aes_dev_t *dev,
                         uint32_t *ct)
{
    ct[0] = aes_read(dev->base, AES_CT0);
    ct[1] = aes_read(dev->base, AES_CT1);
    ct[2] = aes_read(dev->base, AES_CT2);
    ct[3] = aes_read(dev->base, AES_CT3);
}

void aes_encrypt_block(aes_dev_t *dev,
                       const uint32_t *pt,
                       const uint32_t *key,
                       uint32_t *ct)
{
    aes_set_plaintext(dev, pt);
    aes_set_key(dev, key);
    aes_start(dev);
    aes_wait_done(dev);
    aes_get_ciphertext(dev, ct);
}
