#!/bin/sh

for f in */*.jpg;do
    mv $f $(echo $f|sed -e "s/q_game/head_game/");
    mv $f $(echo $f|sed -e "s/menu_top/menu_main/");
    mv $f $(echo $f|sed -e "s/menu02/menu_howto/");
    mv $f $(echo $f|sed -e "s/menu03/menu_quest/");
    mv $f $(echo $f|sed -e "s/menu04/menu_reward/");
    mv $f $(echo $f|sed -e "s/top_get/top_reward/");
    mv $f $(echo $f|sed -e "s/top02/top_reward/");
done


for f in *;do
    mv $f $(echo $f|sed -e "s/_d_/_drpr_/");
    mv $f $(echo $f|sed -e "s/_ｄ_/_drpr_/");
    mv $f $(echo $f|sed -e "s/_grcl_/_fwrs_/");
    mv $f $(echo $f|sed -e "s/_grc_/_fwrs_/");
    mv $f $(echo $f|sed -e "s/_bkrs_/_bkrs2_/");
    mv $f $(echo $f|sed -e "s/_pdgn_/_pdgn2_/");

    mv $f $(echo $f|sed -e "s/icon_oth_comp_/icon_comp_other_/");
    mv $f $(echo $f|sed -e "s/icon_oth_non_/icon_non_other_/");
    mv $f $(echo $f|sed -e "s/icon_oth_cle_/icon_finish_other_/");

    mv $f $(echo $f|sed -e "s/icon_cle_/icon_finish_/");
    mv $f $(echo $f|sed -e "s/icon_cha_/icon_init_/");
    mv $f $(echo $f|sed -e "s/icon_chal_/icon_accept_/");
done


for f in */*.jpg;do
    mv $f $(echo $f|sed -e "s/_sp/_v/");
    mv $f $(echo $f|sed -e "s/_fp/_q/");
done


for f in *.jpg;do
    mv $f $(echo $f|sed -e "s/_sp/_v/");
    mv $f $(echo $f|sed -e "s/_fp/_q/");
done

for f in *;do
    mv $f $(echo $f|sed -e "s/_sp/_v/");
    mv $f $(echo $f|sed -e "s/_fp/_q/");
done
