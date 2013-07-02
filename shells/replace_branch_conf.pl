#!/usr/bin/perl

use strict;
use warnings;

our $CONF_FILE_NAME = $ENV{'current_conf_file'};
our $TEMP_FILE_NAME = $ENV{'temp_conf_file'};

# ユーザーが増えたときはここに追加
our %folder_hash = (
    "newtrunk" => "/amachi/newtrunk",
    "dgame" => "/amachi/dgame",
    "colopl" => "/amachi/colopl",
    );

our @user_names = keys %folder_hash;
our @paths = values %folder_hash;
our $replace_flag = 0;

our $provider = shift @ARGV;  #対象のPFを取得
our $user_path = get_user_project_path(shift @ARGV);   # 引数から対象のユーザパスを取得

sub main {
    # 元ファイルを$conf_file（読込専用）、テンポラリファイルを$tmp_file（書込専用）で開く
    open(my $conf_file, "<", $CONF_FILE_NAME) || die "cant open $CONF_FILE_NAME : $!";
    open(my $tmp_file,">",$TEMP_FILE_NAME) || die "cant open $TEMP_FILE_NAME : $!";
    # ファイルがEOF( END OF FILE ) に到達するまで1行読みこみを繰り返す。
    while(my $line = readline $conf_file){
        # chomp関数で、改行を取り除く
        chomp $line;
        # 現在のlineが変更する部分かどうかチェック
        $replace_flag = set_replace_flag($line);
        if ($replace_flag) {
            $line = line_replace($line);
        }
        # テンポラリファイルに１行書込み
        print $tmp_file $line,"\n";
    }

    close $conf_file;
    close $tmp_file;
}

sub set_replace_flag {
    my $line = shift;
    if ($line =~ m/${provider}/) {
        $replace_flag = 1;
    }
    if ($line =~ m/<\/VirtualHost>/) {
        $replace_flag = 0;
    }
    return $replace_flag;
}

sub get_user_project_path {
    my $user = shift;
    return $folder_hash{$user}
}

sub line_replace {
    my $line = shift;
    foreach my $path (@paths){
        # perl 5.8で動かなかい処理をわける
        if ( $^V gt 'v5.12.0' ) {
            if ($line =~ m/(?<prefix>.*)${path}(?<suffix>.*)/ ) {
                $line = "$+{prefix}$user_path$+{suffix}\n";
                last;
            }
        } else {
            if ($line =~ m/(.*)${path}(.*)/ ) {
                $line = "$1$user_path$2\n";
                last;
            }
        }
    }
    return $line;
}

# main を呼び出し
main();
