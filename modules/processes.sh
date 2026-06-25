#!/bin/bash

process_monitoring() {
    echo "Création de top_cpu.txt"
    echo "    Checking des processus..............."
    ps aux --sort=-%cpu | head -11 \
        > "$REPORT_DIR/top_cpu.txt"
    echo -e "\033[32m[+]\033[0m top_cpu.txt créé"
    echo
    echo "Création de hogs.txt"
    ps aux | grep cpu-hog.sh \
        > "$REPORT_DIR/hogs.txt"
    echo -e "\033[32m[+]\033[0m hogs.txt créé"
    echo
}