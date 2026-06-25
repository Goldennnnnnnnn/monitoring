#!/bin/bash

verify_files() {
    cp $REPORT_DIR/* ./reports/latest/
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
    echo ""
    echo "===== CONTROLE FINAL ====="
    for file in "${FILES[@]}"
    do
        if [ -f "$REPORT_DIR/$file" ]
        then
            echo "[OK] $file"
        else
            echo "[ERREUR] $file"
        fi
    done
}