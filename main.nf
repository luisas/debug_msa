

process REG_ALIGNER {
    container 'luisas/compact'
    tag "reg aligner on $id"
    storeDir "${params.dataset_dir}/out/"

    input:
    tuple val(id), file(seqs)

    output:
    tuple val(id), path("${id}.mbed" ), path ("${id}.aln"), emit: alignmentFile


    script:
    """
    t_coffee -reg -seq $seqs -nseq 100 -tree mbed -method mafftginsi_msa -outfile ${id}.aln -outtree ${id}.mbed 
    """
}

workflow align {
    seqs = Channel.fromPath( params.seqs ).map { item -> [ item.baseName, item] }
    REG_ALIGNER(seqs)
}


workflow {
  align()
}
