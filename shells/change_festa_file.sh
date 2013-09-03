#!/bin/sh


for f in *;do
    mv $f $(echo $f|sed -e "s/_d_/_drpr_/");
    mv $f $(echo $f|sed -e "s/_ｄ_/_drpr_/");
    mv $f $(echo $f|sed -e "s/_grcl/_fwrs/");
    mv $f $(echo $f|sed -e "s/_glcl/_fwrs/");
    mv $f $(echo $f|sed -e "s/_grc_/_fwrs_/");
    mv $f $(echo $f|sed -e "s/_bkrs_/_bkrs2_/");
    mv $f $(echo $f|sed -e "s/_pdgn_/_pdgn2_/");
    mv $f $(echo $f|sed -e "s/_pdng/_pdgn/");
    mv $f $(echo $f|sed -e "s/menue/menu/");
    mv $f $(echo $f|sed -e "s/messag_/message_/");
    mv $f $(echo $f|sed -e "s/icon_accept2_/icon_accept_/");

    mv $f $(echo $f|sed -e "s/icon_oth_comp_/icon_comp_other_/");
    mv $f $(echo $f|sed -e "s/icon_oth_non_/icon_non_other_/");
    mv $f $(echo $f|sed -e "s/icon_oth_cle_/icon_finish_other_/");

    mv $f $(echo $f|sed -e "s/icon_cle_/icon_finish_/");
    mv $f $(echo $f|sed -e "s/icon_cha_/icon_init_/");
    mv $f $(echo $f|sed -e "s/icon_chal_/icon_accept_/");


done

for f in *;do

    if [ `echo $f | grep main` ]; then
        if [ `echo $f | grep bkrs2` ]; then
            mv $f $(echo $f|sed -e "s/_bkrs2//");
        else
            rm $f
        fi
    fi

    if [ `echo $f | grep sample_reward` ]; then
        if [ `echo $f | grep bkrs2` ]; then
            mv $f $(echo $f|sed -e "s/_bkrs2//");
        else
            rm $f
        fi
    fi

    if [ `echo $f | grep status_levelup` ]; then
        if [ `echo $f | grep bkrs2` ]; then
            mv $f $(echo $f|sed -e "s/_bkrs2//");
        else
            rm $f
        fi
    fi

    if [ `echo $f | grep post_message` ]; then
        if [ `echo $f | grep bkrs2` ]; then
            mv $f $(echo $f|sed -e "s/_bkrs2//");
        else
            rm $f
        fi
    fi

    if [ `echo $f | grep free_friend` ]; then
        if [ `echo $f | grep bkrs2` ]; then
            mv $f $(echo $f|sed -e "s/_bkrs2//");
        else
            rm $f
        fi
    fi
done

# for f in *;do
#     mv $f $(echo $f|sed -e "s/_sp/_v/");
# done

# for f in *.jpg;do
#     mv $f $(echo $f|sed -e "s/.jpg/_q.jpg/");
# done
