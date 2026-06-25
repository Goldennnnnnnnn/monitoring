#!/bin/bash

check_services() {
    OUTPUT="$REPORT_DIR/services.txt"
    echo "Création de services.txt"
    echo "    Checking des services...................."
    {
        echo "RUN : $(date)"
        echo "MACHINE : $(hostname)"
        echo "UTILISATEUR COURANT : $(whoami)"
        echo ""

        for service in fake-api log-generator noisy-workers
        do
            if systemctl is-active --quiet "$service"
            then
                echo "$service est OK"
            else
                echo "$service est NOK"
            fi
        done
    } > "$OUTPUT"
    echo -e "\033[32m[+]\033[0m services.txt créé"
    echo
}