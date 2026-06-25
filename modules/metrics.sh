#!/bin/bash

CSV="/var/log/monitoring-lab/data/metrics.csv"

analyze_metrics() {
    OUTPUT="$REPORT_DIR/metrics_summary.txt"
    TOTAL=$(wc -l < "$CSV")
    HIGH_CPU=$(awk -F',' 'NR>1 && $3 >= 95 {count++} END {print count+0}' "$CSV")
    echo "Création de metrics_summary.txt"
    echo "    Checking des anomalies...................."
    {
        echo "Nombre total de lignes : $TOTAL"
        echo "CPU >=95% : $HIGH_CPU"
        echo ""
        echo "5 premières anomalies :"
        awk -F',' 'NR==1 || $3 >=95' "$CSV" | head -6
    } > "$OUTPUT"
    echo -e "\033[32m[+]\033[0m metrics_summary.txt créé"
    echo
}