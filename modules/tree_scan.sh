#!/bin/bash

TREE_DIR="/var/log/monitoring-lab/tmp/tree"

scan_tree() {
    echo "Création de tree_bak.txt"
    find "$TREE_DIR" -type f -name "*.bak" \
        > "$REPORT_DIR/tree_bak.txt"
    echo -e "\033[32m[+]\033[0m tree_bak.txt créé"

    echo "Création de tree_secret.txt"
    find "$TREE_DIR" -type f -print0 \
    | xargs -0 grep -l "SECRET=" \
        > "$REPORT_DIR/tree_secret.txt"
    echo -e "\033[32m[+]\033[0m tree_secret.txt créé"
}