img=ubuntu
tag=latest
if [ $1 ]; then
    if [ $2 ]; then img=$1; shift; fi
    tag=$1; shift
fi
docker images
if [ "`docker images|awk '/^yx9527\/'"$img"'\s+'"$tag"'/'`" ]; then
    docker tag yx9527/$img:$tag $img:$tag
else
    docker tag $img:$tag yx9527/$img:$tag
fi
cat > Dockerfile << EOF
FROM $img:$tag
RUN sed -i "s/^\(`id -un`\):\(\w\+\):\(\w\+\):\(\w\+\):/\1:\2:`id -u`:`id -g`:/" /etc/passwd && \\
    sed -i "s/^\(`id -un`\):\(\w\+\):\(\w\+\):/\1:\2:`id -g`:/" /etc/group
EOF
docker build . -t $img:$tag
for i in `docker images|awk '/<none>/{print $3}'`; do docker rmi $i; done
docker images
