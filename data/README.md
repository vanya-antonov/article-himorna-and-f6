# Copying files

## from /data/mazurovev/all_marks/
```
# our_fantom_fantom_aso_genes_confusion_matrix.tsv
cat all_marks.txt \
| xargs -tI{} cp -v /data/mazurovev/all_marks/{}/our_fantom_fantom_aso_genes_confusion_matrix.tsv  all_marks/{}/ 

# our_fantom_fantom_aso_genes_association.tsv
cat all_marks.txt \
| xargs -tI{} cp -v /data/mazurovev/all_marks/{}/our_fantom_fantom_aso_genes_association.tsv  all_marks/{}/ 
```
