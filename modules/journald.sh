#!/bin/bash

collect_logs() {
    JOURNAL="$REPORT_DIR/journald.txt"
    ERRORS="$REPORT_DIR/journald_errors.txt"
    echo "Création de journald.txt & journald_errors.txt "
    {
        echo "===== FAKE API ====="
        journalctl -u fake-api -n 30 --no-pager
        echo
        echo "===== LOG GENERATOR ====="
        journalctl -u log-generator -n 30 --no-pager
    } > "$JOURNAL"
    {
        journalctl -u fake-api -n 30 --no-pager
        journalctl -u log-generator -n 30 --no-pager
    } | grep -E "ERROR|CRITICAL" > "$ERRORS"
    echo -e "\033[32m[+]\033[0m journald.txt & journald_errors.txt créé"
    echo
}