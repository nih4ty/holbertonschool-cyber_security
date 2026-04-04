#!/usr/bin/python3
"""
Bu modul işləyən bir prosesin heap yaddaşını oxuyur və
göstərilən string-i axtararaq onu yeni string ilə əvəz edir.
"""

import sys
import os


def print_usage_error():
    """İstifadə qaydasını stdout-a çap edir və 1 statusu ilə çıxır."""
    print("Usage: {} pid search_string replace_string".format(sys.argv[0]))
    sys.exit(1)


def main():
    """
    Əsas funksiya: Arqumentləri yoxlayır, /proc/[pid]/maps faylından
    heap ünvanlarını tapır və /proc/[pid]/mem faylını dəyişir.
    """
    if len(sys.argv) != 4:
        print_usage_error()

    pid = sys.argv[1]
    search_string = sys.argv[2]
    replace_string = sys.argv[3]

    maps_file = "/proc/{}/maps".format(pid)
    mem_file = "/proc/{}/mem".format(pid)

    if not os.path.exists(maps_file) or not os.path.exists(mem_file):
        print("Error: Process doesn't exist or permission denied.")
        sys.exit(1)

    heap_start = None
    heap_end = None

    # 1. Heap yaddaşının başlanğıc və son ünvanlarını tapmaq
    try:
        with open(maps_file, 'r') as m_file:
            for line in m_file:
                if "[heap]" in line:
                    address_range = line.split(' ')[0]
                    start_str, end_str = address_range.split('-')
                    heap_start = int(start_str, 16)
                    heap_end = int(end_str, 16)
                    break
    except Exception as e:
        print("Error reading maps file: {}".format(e))
        sys.exit(1)

    if heap_start is None or heap_end is None:
        print("Error: Could not find [heap] in {}.".format(maps_file))
        sys.exit(1)

    # 2. Heap-i oxumaq və string-i dəyişdirmək
    try:
        with open(mem_file, 'r+b') as mem:
            mem.seek(heap_start)
            heap_size = heap_end - heap_start
            heap_data = mem.read(heap_size)

            search_bytes = search_string.encode('ascii')
            replace_bytes = replace_string.encode('ascii')

            # Köhnə string-in heap daxilindəki mövqeyini tapırıq
            offset = heap_data.find(search_bytes)

            if offset == -1:
                print("Error: String '{}' not found".format(search_string))
                sys.exit(1)

            # Əgər yeni string qısadırsa, qalan hissəni null baytla doldururuq
            if len(replace_bytes) < len(search_bytes):
                padding = len(search_bytes) - len(replace_bytes)
                replace_bytes += b'\x00' * padding

            # Dəqiq ünvana gedib yeni string-i yazırıq
            mem.seek(heap_start + offset)
            mem.write(replace_bytes)

    except Exception as e:
        print("Error accessing memory: {}".format(e))
        sys.exit(1)


if __name__ == "__main__":
    main()
