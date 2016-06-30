list=`ls | grep -v gen.sh | grep -v src`

for i in $list
do
src/curve2array $i
done

cat $list > all.pas
