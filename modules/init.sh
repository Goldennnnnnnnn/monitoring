#!/bin/bash

show_context() {
    echo -e "\033[34m=====================================\033[0m"
    echo "RUN : $(date)"
    echo "MACHINE : $(hostname)"
    echo "UTILISATEUR : $(whoami)"
    echo -e "\033[34m=====================================\033[0m"
}

create_report_dir() {
    echo
    echo "Création du dossier rapport & latest"
    mkdir -p "$REPORT_DIR"
    mkdir -p "$BASE_DIR/reports/latest/"
    echo -e "\033[32m[+]\033[0m Dossier créé : $REPORT_DIR & $BASE_DIR/reports/latest/"
    echo
}