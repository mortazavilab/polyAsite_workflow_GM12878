snakemake \
    -p \
    --use-singularity \
    --singularity-args "--bind ${PWD}" \
    --configfile config.yaml \
    --cluster-config cluster_config.json \
    --jobscript jobscript.sh \
    --cores 50 \
    --local-cores 5 \
    --cluster "sbatch --cpus-per-task {cluster.threads} \
              --time {cluster.time} -o {params.cluster_log} \
              -p standard --export=JOB_NAME={rule} \
              --open-mode=append" \
    &>> run_update.c2c12.log
