#!/bin/bash
#delete unwanted parts of seq. names, complete bodo name, delete extra Tgrayi seq
cd "/home/skalda/Dropbox/CEITEC_lab"
sed -i -r -e 's/Amissi_XP_006272801_1/Amissi_XP_006272801_1_PREDICTED_ALKBH5/g' \
-e 's/Athali_NP_001031159_1/Athali_NP_001031159_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001031793_1/Athali_NP_001031793_1_oxidoreductase_2OG-Fe_II_oxygenase/g' \
-e 's/Athali_NP_001031794_1/Athali_NP_001031794_1_oxidoreductase_2OG-Fe_II_oxygenase/g' \
-e 's/Athali_NP_001077911_1/Athali_NP_001077911_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001117455_1/Athali_NP_001117455_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001117456_1/Athali_NP_001117456_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001189546_1/Athali_NP_001189546_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001324029_1/Athali_NP_001324029_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001324030_1/Athali_NP_001324030_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001324031_1/Athali_NP_001324031_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001324032_1/Athali_NP_001324032_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001324033_1/Athali_NP_001324033_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001324034_1/Athali_NP_001324034_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001324035_1/Athali_NP_001324035_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_001328937_1/Athali_NP_001328937_1_oxidoreductase_2OG-Fe_II_oxygenase/g' \
-e 's/Athali_NP_001328938_1/Athali_NP_001328938_1_oxidoreductase_2OG-Fe_II_oxygenase/g' \
-e 's/Athali_NP_175328_2/Athali_NP_175328_2_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_179387_1/Athali_NP_179387_1_2-oxoglutarate_2OG_and_Fe_II_dependent_oxygenase/g' \
-e 's/Athali_NP_182329_2/Athali_NP_182329_2_oxidoreductase_2OG-Fe_II_oxygenase/g' \
-e 's/Athali_NP_192203_1/Athali_NP_192203_1_oxidoreductase_2OG-Fe_II_oxygenase/g' \
-e 's/Athali_NP_195332_2/Athali_NP_195332_2_oxidoreductase_2OG-Fe_II_oxygenase/g' \
-e 's/Bbelch_XP_019614035_1/Bbelch_XP_019614035_1_PREDICTED_ALKBH5-like/g' \
-e 's/Btauru_NP_001192446_1/Btauru_NP_001192446_1_ALKBH5/g' \
-e 's/Cpicta_XP_005289064_1/Cpicta_XP_005289064_1_PREDICTED_ALKBH5/g' \
-e 's/Cpicta_XP_008162972_1/Cpicta_XP_008162972_1_PREDICTED_ALKBH5/g' \
-e 's/Drerio_NP_001070855_1/Drerio_NP_001070855_1_ALKBH5_Danio_rerio/g' \
-e 's/Ehuxle_XP_005778725_1/Ehuxle_XP_005778725_1_hypothetical_protein/g' \
-e 's/Epalli_XP_020902891_1/Epalli_XP_020902891_1_ALKBH5-like/g' \
-e 's/Ggallu_XP_001233463_1/Ggallu_XP_001233463_1_PREDICTED_ALKBH/g' \
-e 's/Ggallu_XP_004945254_1/Ggallu_XP_004945254_1_PREDICTED_ALKBH5/g' \
-e 's/Gjapon_XP_015264839_1/Gjapon_XP_015264839_1_PREDICTED_ALKBH5/g' \
-e 's/Hsapie_NP_060228_3/Hsapie_NP_060228_3_ALKBH5/g' \
-e 's/Hvulga_XP_002156519_1/Hvulga_XP_002156519_1_PREDICTED_ALKBH5-like/g' \
-e 's/Lchalu_XP_005996770_1/Lchalu_XP_005996770_1_PREDICTED_ALKBH5-like/g' \
-e 's/Lchalu_XP_005997530_2/Lchalu_XP_005997530_2_PREDICTED_ALKBH5/g' \
-e 's/Mmuscu_NP_766531_2/Mmuscu_NP_766531_2_PREDICTED_ALKBH5/g' \
-e 's/Nparke_XP_018424809_1/Nparke_XP_018424809_1_PREDICTED_ALKBH5/g' \
-e 's/Nvecte_XP_001632149_1/Nvecte_XP_001632149_1_predicted_protein/g' \
-e 's/Ohanna_ETE72190_1/Ohanna_ETE72190_1_putative_alpha-ketoglutarate-dependent_dioxygenase_ABH5_partial/g' \
-e 's/Osativ_NP_001056738_1/Osativ_NP_001056738_1/g' \
-e 's/Rfilos_ETO11769_1/Rfilos_ETO11769_1_hypothetical_protein/g' \
-e 's/Rtypus_XP_020381632_1/Rtypus_XP_020381632_1_LOW_QUALITY_PROTEIN_ALKBH5-like/g' \
-e 's/Rtypus_XP_020390513_1/Rtypus_XP_020390513_1_ALKBH5-like/g' \
-e 's/Ttherm_XP_001009552_2/Ttherm_XP_001009552_2_hypothetical_protein/g' \
-e 's/Vcarte_XP_002952186_1/Vcarte_XP_002952186_1/g' \
-e 's/Xlaevi_NP_001085704_1/Xlaevi_NP_001085704_1/g' \
-e 's/Xlaevi_XP_018089815_1/Xlaevi_XP_018089815_1/g' \
-e 's/Xlaevi_XP_018093287_1/Xlaevi_XP_018093287_1/g' rooted_RAxML_bipartitionsBranchLabels.ALKBH5_OG0005435_quick