#!/bin/bash

LOG_FILE="/var/log/monitoring-lab/data/app.log"

analyze_app_log() {
    SUMMARY="$REPORT_DIR/app_summary.txt"
    TOTAL=$(wc -l < "$LOG_FILE")
    ERRORS=$(grep -c "ERROR" "$LOG_FILE")
    CRITICALS=$(grep -c "CRITICAL" "$LOG_FILE")
    echo "Création de app_summary.txt & app_redacted.log"
    echo "    Checking des lines/errors/criticals/hosts...................."
    {
        echo "Nombre total de lignes : $TOTAL"
        echo "Nombre ERROR : $ERRORS"
        echo "Nombre CRITICAL : $CRITICALS"
        echo ""
        echo "Top 5 des hôtes :"
        awk '{print $3}' "$LOG_FILE" \
            | sort \
            | uniq -c \
            | sort -rn \
            | head -5
    } > "$SUMMARY"
    cp "$LOG_FILE" "$REPORT_DIR/app_redacted.log"
    echo "[+] app_summary.txt & app_redacted.log créé"
    echo
}