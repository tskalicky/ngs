#!/bin/bash
#delete unwanted parts of seq. names, complete bodo name, delete extra Tgrayi seq
cd "/home/skalda/Dropbox/CEITEC_lab"
awk '{gsub(/Amissi_XP_006264888_2/,"Amissi_XP_006264888_2_PREDICTED_FTO_isoform X10"); \
gsub(/Amissi_XP_019353001_1/,"Amissi_XP_019353001_1_PREDICTED_FTO_isoform X1"); \
gsub(/Amissi_XP_019353002_1/,"Amissi_XP_019353002_1_PREDICTED_FTO_isoform X2"); \
gsub(/Amissi_XP_019353003_1/,"Amissi_XP_019353003_1_PREDICTED_FTO_isoform X3"); \
gsub(/Amissi_XP_019353004_1/,"Amissi_XP_019353004_1_PREDICTED_FTO_isoform X4"); \
gsub(/Amissi_XP_019353005_1/,"Amissi_XP_019353005_1_PREDICTED_FTO_isoform X5"); \
gsub(/Amissi_XP_019353006_1/,"Amissi_XP_019353006_1_PREDICTED_FTO_isoform X6"); \
gsub(/Amissi_XP_019353007_1/,"Amissi_XP_019353007_1_PREDICTED_FTO_isoform X7"); \
gsub(/Amissi_XP_019353008_1/,"Amissi_XP_019353008_1_PREDICTED_FTO_isoform X8"); \
gsub(/Amissi_XP_019353009_1/,"Amissi_XP_019353009_1_PREDICTED_FTO_isoform X9"); \
gsub(/Btauru_NP_001091611_1/,"Btauru_NP_001091611_1_FTO"); \
gsub(/Btauru_XP_010812872_1/,"Btauru_XP_010812872_1_PREDICTED_FTO_isoform X1"); \
gsub(/Btauru_XP_015331264_1/,"Btauru_XP_015331264_1_PREDICTED_FTO_isoform X2"); \
gsub(/Cowcza_XP_004347827_1/,"Cowcza_XP_004347827_1_hypothetical protein CAOG_04002"); \
gsub(/Cpicta_XP_005289845_1/,"Cpicta_XP_005289845_1_PREDICTED_FTO_isoform X1"); \
gsub(/Cpicta_XP_005289846_1/,"Cpicta_XP_005289846_1_PREDICTED_FTO_isoform X3"); \
gsub(/Cpicta_XP_008165163_1/,"Cpicta_XP_008165163_1_PREDICTED_FTO_isoform X2"); \
gsub(/Drerio_XP_001345910_4/,"Drerio_XP_001345910_4_FTO_isoform X2"); \
gsub(/Drerio_XP_009301626_1/,"Drerio_XP_009301626_1_FTO_isoform X1"); \
gsub(/Drerio_XP_021327673_1/,"Drerio_XP_021327673_1_FTO_isoform X1"); \
gsub(/Drerio_XP_021327674_1/,"Drerio_XP_021327674_1_FTO_isoform X2"); \
gsub(/Esilic_CBJ31645_1/,"Esilic_CBJ31645_1_conserved unknown protein"); \
gsub(/Esilic_CBJ31658_1/,"Esilic_CBJ31658_1_conserved unknown protein"); \
gsub(/Ggallu_NP_001172076_1/,"Ggallu_NP_001172076_1_FTO"); \
gsub(/Gjapon_XP_015277713_1/,"Gjapon_XP_015277713_1_PREDICTED_FTO"); \
gsub(/Hsapie_NP_001073901_1/,"Hsapie_NP_001073901_1_FTO"); \
gsub(/Hsapie_XP_011521615_1/,"Hsapie_XP_011521615_1_PREDICTED_FTO_isoform X1"); \
gsub(/Hsapie_XP_011521616_1/,"Hsapie_XP_011521616_1_PREDICTED_FTO_isoform X4"); \
gsub(/Hsapie_XP_011521617_1/,"Hsapie_XP_011521617_1_PREDICTED_FTO_isoform X5"); \
gsub(/Hsapie_XP_011521618_1/,"Hsapie_XP_011521618_1_PREDICTED_FTO_isoform X6"); \
gsub(/Hsapie_XP_016879143_1/,"Hsapie_XP_016879143_1_PREDICTED_FTO_isoform X2"); \
gsub(/Hsapie_XP_016879144_1/,"Hsapie_XP_016879144_1_PREDICTED_FTO_isoform X3"); \
gsub(/Hsapie_XP_016879145_1/,"Hsapie_XP_016879145_1_PREDICTED_FTO_isoform X7"); \
gsub(/Hsapie_XP_016879146_1/,"Hsapie_XP_016879146_1_PREDICTED_FTO_isoform X8"); \
gsub(/Hsapie_XP_016879147_1/,"Hsapie_XP_016879147_1_PREDICTED_FTO_isoform X9"); \
gsub(/Lchalu_XP_005997313_1/,"Lchalu_XP_005997313_1_PREDICTED_FTO"); \
gsub(/Mmuscu_NP_036066_2/,"Mmuscu_NP_036066_2_FTO"); \
gsub(/Mmuscu_XP_006531099_1/,"Mmuscu XP_006531099_1_PREDICTED_FTO_isoform X1"); \
gsub(/Nparke_XP_018410223_1/,"Nparke_XP_018410223_1_PREDICTED_FTO"); \
gsub(/Ohanna_ETE58676_1/,"Ohanna_ETE58676_1_hypothetical protein L345_15602_ partial"); \
gsub(/Rtypus_XP_020366564_1/,"Rtypus_XP_020366564_1_FTO_partial"); \
gsub(/Tpseud_XP_002287957_1/,"Tpseud_XP_002287957_1_hypothetical protein"); \
gsub(/Xlaevi_NP_001087481_1/,"Xlaevi_Xlaevi NP_001087481_1"); \
gsub(/Xlaevi_XP_018112307_1/,"Xlaevi_Xlaevi XP_018112307_1"); \
gsub(/Xlaevi_XP_018112308_1/,"Xlaevi_Xlaevi XP_018112308_1"); \
gsub(/Xlaevi_XP_018112309_1/,"Xlaevi_Xlaevi XP_018112309_1"); \
gsub(/Xlaevi_XP_018112310_1/,"Xlaevi_Xlaevi XP_018112310_1");}' rooted_RAxML_bipartitionsBranchLabels.FTO_OG0005665_quick
