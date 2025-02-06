img=ubuntu
tag=latest
if [ $1 ]; then
    if [ $2 ]; then img=$1; shift; fi
    tag=$1; shift
fi
docker images
if [ "`docker images|awk '/^yangxu\/'"$img"'\s+'"$tag"'/'`" ]; then
    docker tag yangxu/$img:$tag $img:$tag
else
    docker tag $img:$tag yangxu/$img:$tag
fi
cat > Dockerfile << EOF
FROM $img:$tag
RUN sed -i "s/^\(`id -un`\):\(\w\+\):\(\w\+\):\(\w\+\):/\1:\2:`id -u`:`id -g`:/" /etc/passwd && \\
    sed -i "s/^\(`id -un`\):\(\w\+\):\(\w\+\):/\1:\2:`id -g`:/" /etc/group
EOF
docker build . -t $img:$tag
# docker run -it --rm $img:$tag /bin/bash -c " \\
#     for i in /usr/lib/x86_64-linux-gnu/libQt5Core.so.5; do if [ -f \$i ]; then \\
#         ls -al \$i.*.*; \\
#         strip --remove-section=.note.API-tag \$i; \\
#         ls -al \$i.*.*; \\
#     fi done "
for i in `docker images|awk '/<none>/{print $3}'`; do docker rmi $i; done
docker images
