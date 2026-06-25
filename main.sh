#!/bin/bash

BASE_DIR="/opt/monitoring-lab/$USER"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
REPORT_DIR="$BASE_DIR/reports/run-$TIMESTAMP"

export REPORT_DIR

source modules/init.sh
source modules/services.sh
source modules/journald.sh
source modules/processes.sh
source modules/app_log.sh
source modules/metrics.sh
source modules/tree_scan.sh
source modules/checks.sh

show_context
create_report_dir
check_services
collect_logs
process_monitoring
analyze_app_log
analyze_metrics
scan_tree
verify_files