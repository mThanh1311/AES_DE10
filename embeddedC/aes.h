/*
 * aes.h
 *
 *  Created on: Dec 19, 2025
 *      Author: AD
 */

#ifndef AES_H_
#define AES_H_

#include <stdint.h>
#include <stdio.h>

typedef enum {
    AES_KEY_128 = 4,
    AES_KEY_192 = 6,
    AES_KEY_256 = 8
} aes_key_size_t;

typedef struct {
    uint32_t base;
    aes_key_size_t key_words;
} aes_dev_t;

void aes_init(aes_dev_t *dev,
              uint32_t base,
              aes_key_size_t key_size);

void aes_set_plaintext(aes_dev_t *dev,
                       const uint32_t *pt);

void aes_set_key(aes_dev_t *dev,
                 const uint32_t *key);

void aes_start(aes_dev_t *dev);

void aes_wait_done(aes_dev_t *dev);

void aes_get_ciphertext(aes_dev_t *dev,
                         uint32_t *ct);

void aes_encrypt_block(aes_dev_t *dev,
                       const uint32_t *pt,
                       const uint32_t *key,
                       uint32_t *ct);


#endif /* AES_H_ */
