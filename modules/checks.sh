#!/bin/bash

verify_files() {
    cp $REPORT_DIR/* $BASE_DIR/reports/latest/
    FILES=(
        services.txt
        journald.txt
        journald_errors.txt
        top_cpu.txt
        hogs.txt
        app_summary.txt
        app_redacted.log
        metrics_summary.txt
        tree_bak.txt
        tree_secret.txt
    )
    echo
    echo -e "\033[34m===== CONTROLE FINAL =====\033[0m"
    for file in "${FILES[@]}"
    do
        if [ -f "$REPORT_DIR/$file" ]
        then
            echo -e "\033[32m[OK]\033[0m $file"
        else
            echo -e "\033[31m[ERREUR]\033[0m $file"
        fi
    done
    echo "Rapport disponible dans : $REPORT_DIR & $BASE_DIR/reports/latest/"
}