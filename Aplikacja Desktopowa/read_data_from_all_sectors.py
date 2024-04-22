from py122u import nfc
import time

def decode_data_as_ascii(data):
    try:
        # Convert each byte in the data to an ASCII character only if it is a printable character
        readable_str = ''.join(chr(byte) for byte in data if 32 <= byte <= 126)
        return readable_str if readable_str else None  # Return None if the string is empty
    except Exception as e:
        print(f"Error decoding data: {e}")
        return None


def read_data_from_all_card_sectors():
    reader = nfc.Reader()
    try:
        reader.connect()
        blocks_per_sector = 4
        key_type = 0x61
        key = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]

        all_data = ""
        # Reading data from all sectors and blocks
        for sector in range(1, 16):
            text = ""
            for block in range(0, blocks_per_sector):
                block_to_read = sector * blocks_per_sector + block
                reader.load_authentication_data(0x01, key)
                reader.authentication(block_to_read, key_type, 0x01)
                read_data = reader.read_binary_blocks(block_to_read, 16)

                decoded_data = decode_data_as_ascii(read_data)
                if decoded_data and decoded_data != "@":
                    text += decoded_data
            if text:
                print(f"Data from sector {sector}: {text}")
                all_data += text
        return all_data

    except nfc.error.InstructionFailed as e:
        print(f"An error occurred: {e}")
        return None
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None


if __name__ == '__main__':

    d = read_data_from_all_card_sectors()
    print(d)