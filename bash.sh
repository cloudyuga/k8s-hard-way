for d in {0..7}
do
    ( cd "$d"-* && sed -i '/```command/i\\' *.md )
done
