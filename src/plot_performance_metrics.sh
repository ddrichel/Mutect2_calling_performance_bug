#!/usr/bin/bash

set -eox

./plot_performance_metrics.R "../callsets_performance/WES_FD_TN_4181_filter_som_py.stats.csv"  "../callsets_performance/WES_FD_TN_4190_filter_som_py.stats.csv" "Performance metrics: Mutect2 tumor-normal mode v4.1.8.1 vs. v4.1.9.0"

