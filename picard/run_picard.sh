#!/bin/bash


star_bam_output=~/projects/motrpac/star/output_bam
picard_script=~/projects/motrpac/picard/picard_motrpac.sh

# RD014.Aligned.sortedByCoord.out.bam
# RD014.Aligned.toTranscriptome.out.bam


ls -1 $star_bam_output/*.sortedByCoord.out.bam | awk '{match($1, /[/]*([^/]*)\.out\.bam/, arr); print arr[1]}' | sort | uniq | \
awk -v bam_output=$star_bam_output 'BEGIN{OFS="\t"}{print bam_output"/"$1".out.bam"}' | \
awk -v pspt=${picard_script} '{print "sbatch",pspt,$1}'
# parallel --jobs 10 --col-sep "\t" "${picard_script} {1}"

exit

wait

awk 'BEGIN{OFS="\t"}$1 ~ /(LIBRARY)|(kp1)/{match(FILENAME, /(RD[0-9]+)\./, arr); print arr[1], $0}' picard_output/*.Aligned.sortedByCoord_markdup_metrix.txt | awk '{if(NR==1){sub(/RD[0-9]+/, "sample_id", $1); print $0}if(NR > 1 && $2 !~ /LIBRARY/){print $0}}' > kp1_metrix.txt
