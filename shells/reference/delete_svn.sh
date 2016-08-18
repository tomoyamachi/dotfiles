echo "以下ディレクトリのsvn情報を削除します"
pwd
echo "実行してよろしいですか？(y / n)"
read check
if [ "$check" = "y" ];
then
	find ./ -name .svn | xargs rm -rf
	echo "削除しました"
fi
