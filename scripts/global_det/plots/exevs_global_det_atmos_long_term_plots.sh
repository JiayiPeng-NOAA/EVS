#!/bin/bash
###############################################################################
# Name of Script: exevs_global_det_atmos_long_term_plots.sh
# Purpose of Script: This script generates long term
#                    verification plots for the atmospheric component
#                    of global deterministic models
# Log history:
###############################################################################

set -x

# Set run mode
if [ $RUN_ENVIR = nco ]; then
    export evs_run_mode="production"
else
    export evs_run_mode=$evs_run_mode
fi
echo "RUN MODE:$evs_run_mode"
if [ $evs_run_mode = production ] && [ $envir = prod ]; then
    echo "exevs_global_det_atmos_long_term_plots.sh does run in production; exit"
    exit 0
fi

# Make plots
python $USHevs/global_det/global_det_atmos_plots_long_term.py
status=$?
[[ $status -ne 0 ]] && exit $status
[[ $status -eq 0 ]] && echo "Succesfully ran global_det_atmos_plots_long_term.py"
echo

# Copy files to desired location
if [ $SENDCOM = YES ]; then
    # Make and copy tar file
    large_tar_file=${DATA}/evs.plots.${COMPONENT}.atmos.${RUN}.v${VDATEYYYY}${VDATEmm}.tar
    if [ $VDATEmm = 12 ]; then
        tar -cvf ${large_tar_file} -C ${DATA}/${VDATEYYYY}_${VDATEmm}_ACC/images . -C ${DATA}/monthly/grid2grid/images . -C ${DATA}/yearly/grid2grid/images .
    else
        tar -cvf ${large_tar_file} -C ${DATA}/${VDATEYYYY}_${VDATEmm}_ACC/images . -C ${DATA}/monthly/grid2grid/images .
    fi
    cp -v $large_tar_file $COMOUT/.
fi
