#!/bin/bash

show_context() {
    echo "====================================="
    echo "RUN : $(date)"
    echo "MACHINE : $(hostname)"
    echo "UTILISATEUR : $(whoami)"
    echo "====================================="
}

create_report_dir() {
    echo
    echo "Création du dossier rapport & latest"
    mkdir -p "$REPORT_DIR"
    mkdir -p "$BASE_DIR/reports/latest/"
    echo "[+] Dossier créé : $REPORT_DIR & $BASE_DIR/reports/latest/"
    echo
}