



//------------------------------TIDDIT----------------------------------    

TIDDIT_exec_file = file( "${params.TIDDIT_path}" )

process TIDDIT {
    publishDir "${params.workingDir}", mode: 'copy', overwrite: true
    errorStrategy 'ignore'      
        //tag { bam_file }
    
        cpus 1
        time "2d"
        
    input:

    set ID, bam, dels_vcf, large_svs_vcf, phased_variants_vcf from wgs_outs_TIDDIT
    
    output:
    set ID, "${ID}_TIDDIT.vcf", "${ID}_TIDDIT.tab", "${ID}_TIDDIT_filtered.vcf" into TIDDIT_output
    
    script:
    """
        python ${TIDDIT_exec_file} --sv -b ${bam} -i 20000 -r 100 -p ${params.TIDDIT_pairs} -q ${params.TIDDIT_q} -o ${ID}_TIDDIT
        cat ${ID}_TIDDIT.vcf | grep -v hs37 > ${ID}_TIDDIT_filtered.vcf
    """
    }

    // outputs can only be used once as input in a new process, therefor we copy them into several identical outputs. 
    TIDDIT_output.into {
    TIDDIT_output_svdbmerge
    TIDDIT_output_GlenX
}
