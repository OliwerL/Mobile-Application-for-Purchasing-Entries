from py122u import nfc

def decode_data_as_ascii(data):
    try:
        return ''.join(chr(byte) for byte in data)
    except Exception as e:
        print(f"Error decoding data: {e}")
        return None

def write_and_read_card(message):
    reader = nfc.Reader()
    try:
        reader.connect()
        blocks_per_sector = 4
        key_type = 0x61
        key = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
        sector = 2  # Choose a sector that you can safely write to, avoiding sector 0
        block_to_write = sector * blocks_per_sector + 2  # Choosing the third block of the sector

        # Authentication before writing and reading
        reader.load_authentication_data(0x01, key)
        reader.authentication(block_to_write, key_type, 0x01)

        # Writing data to the card
        # Ensure that the message is exactly 16 bytes (pad if necessary)
        message = message.encode('ascii')
        if len(message) > 16:
            print("Message too long, must be 16 bytes or less")
            return
        elif len(message) < 16:
            message += b' ' * (16 - len(message))  # Padding with spaces

        # Update the number of bytes argument
        reader.update_binary_blocks(block_to_write, 16, message)  # Fixed: Added number of bytes to update
        print(f"Written to block {block_to_write}: {message}")

        # Reading data back
        read_data = reader.read_binary_blocks(block_to_write, 16)  # Length to read (16 bytes)
        print(f"Read from block {block_to_write}: {read_data}")
        print(decode_data_as_ascii(read_data))

    except nfc.error.InstructionFailed as e:
        print(f"An error occurred: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# Example usage:
write_and_read_card("Test Test!")
