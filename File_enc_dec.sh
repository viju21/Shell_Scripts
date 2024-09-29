#!/bin/bash
#Script_name: File_enc_dec.sh
# Author: Vijay Sankar C
# Description: This script encrypts and decrypts files using AES-256-CBC encryption.

# Function to encrypt a file
encrypt_file() {
    read -sp "Enter passphrase: " passphrase
    echo
    read -sp "Confirm passphrase: " passphrase_confirm
    echo

    if [ "$passphrase" != "$passphrase_confirm" ]; then
        echo "Passphrases do not match."
        exit 1
    fi

    read -p "Enter the file to encrypt: " input_file
    read -p "Enter the output encrypted file name: " output_file

    if [ ! -f "$input_file" ]; then
        echo "The file $input_file does not exist."
        exit 1
    fi

    openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -k "$passphrase"

    if [ $? -eq 0 ]; then
        echo "File $input_file has been encrypted to $output_file."
    else
        echo "Encryption failed."
        exit 1
    fi
}

# Function to decrypt a file
decrypt_file() {
    read -sp "Enter passphrase: " passphrase
    echo

    read -p "Enter the encrypted file to decrypt: " input_file
    read -p "Enter the output decrypted file name: " output_file

    if [ ! -f "$input_file" ]; then
        echo "The file $input_file does not exist."
        exit 1
    fi

    openssl enc -d -aes-256-cbc -in "$input_file" -out "$output_file" -k "$passphrase"

    if [ $? -eq 0 ]; then
        echo "File $input_file has been decrypted to $output_file."
    else
        echo "Decryption failed. Check your passphrase."
        exit 1
    fi
}

# Main menu
while true; do
    echo "File Encryption/Decryption Tool"
    echo "1. Encrypt a file"
    echo "2. Decrypt a file"
    echo "3. Exit"
    read -p "Enter your choice: " choice

    case "$choice" in
        1)
            encrypt_file
            ;;
        2)
            decrypt_file
            ;;
        3)
            echo "Exiting."
            exit
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done

