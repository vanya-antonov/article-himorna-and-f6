import pandas as pd
import scipy.stats as stats
from statsmodels.stats.multitest import multipletests


def makeExactFisherTestFromFiles(confusion_matrix_fn, genes_association_fn):
    confuion_df = pd.read_csv(confusion_matrix_fn, sep="\t")
    df = pd.read_csv(genes_association_fn, sep="\t")

    pvalue = []
    mm_pvalue = []
    mp_pvalue = []
    pm_pvalue = []
    pp_pvalue = []
    for index, row in confuion_df.iterrows():
        _, pv = stats.fisher_exact([[row["TP"], row["FP"]], [row["FN"], row["TN"]]])
        pvalue.append(pv)

        _, mm_pv = stats.fisher_exact(
            [[row["mm_TP"], row["mm_FP"]], [row["mm_FN"], row["mm_TN"]]]
        )
        mm_pvalue.append(mm_pv)

        _, mp_pv = stats.fisher_exact(
            [[row["mp_TP"], row["mp_FP"]], [row["mp_FN"], row["mp_TN"]]]
        )
        mp_pvalue.append(mp_pv)

        _, pm_pv = stats.fisher_exact(
            [[row["pm_TP"], row["pm_FP"]], [row["pm_FN"], row["pm_TN"]]]
        )
        pm_pvalue.append(pm_pv)

        _, pp_pv = stats.fisher_exact(
            [[row["pp_TP"], row["pp_FP"]], [row["pp_FN"], row["pp_TN"]]]
        )
        pp_pvalue.append(pp_pv)

    adjusted_pvalue = multipletests(pvalue, alpha=0.05, method="fdr_bh")
    adjusted_mm_pvalue = multipletests(mm_pvalue, alpha=0.05, method="fdr_bh")
    adjusted_mp_pvalue = multipletests(mp_pvalue, alpha=0.05, method="fdr_bh")
    adjusted_pm_pvalue = multipletests(pm_pvalue, alpha=0.05, method="fdr_bh")
    adjusted_pp_pvalue = multipletests(pp_pvalue, alpha=0.05, method="fdr_bh")

    pvalue_df = pd.DataFrame(
        {
            "pvalue": pvalue,
            "mm_pvalue": mm_pvalue,
            "mp_pvalue": mp_pvalue,
            "pm_pvalue": pm_pvalue,
            "pp_pvalue": pp_pvalue,
            "adj_pvalue": adjusted_pvalue[1],
            "mm_adj_pvalue": adjusted_mm_pvalue[1],
            "mp_adj_pvalue": adjusted_mp_pvalue[1],
            "pm_adj_pvalue": adjusted_pm_pvalue[1],
            "pp_adj_pvalue": adjusted_pp_pvalue[1],
        }
    )

    df_pv = pd.concat([df[["lncRNAId", "lncRNAName"]], pvalue_df], axis=1)
    df_pv = df_pv[
        df_pv.apply(
            lambda row: len([p for p in row.tolist()[3:] if float(p) < 0.05]) != 0,
            axis=1,
        )
    ]
    # df_pv.to_csv("../all_marks/" + target + "/" + our_fantom_file_name + annotation_prefix + "_genes_association_pvalues.tsv", sep="\t", index=None)

    return df_pv
