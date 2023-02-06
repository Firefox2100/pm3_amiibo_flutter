import os
import sys
import getopt
import binascii

root_path = ""
output_path = ""


def rename(path: str):
    file_in = open(path, "rb")
    
    data = bytearray(file_in.read())
    head = data[84:88].hex()
    tail = data[88:92].hex()
    
    file_out = open(output_path + head + "_" + tail + ".bin", "wb")
    file_out.write(data)


def read_files(path: str):
    for root, ds, fs, in os.walk(path):
        for f in fs:
            if f.endswith(".bin"):
                rename(os.path.join(root, f))


if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:],"hi:o:",["ipath=","opath="])
    except getopt.GetoptError:
        print('bin_rename.py -i <input_path> -o <output_path>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('bin_rename.py -i <input_path> -o <output_path>')
            sys.exit()
        elif opt in ("-i", "--ipath"):
            root_path = arg
        elif opt in ("-o", "--opath"):
            output_path = arg
