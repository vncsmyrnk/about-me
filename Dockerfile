FROM openresty/openresty:alpine
RUN apk add --no-cache lua5.1 lua-dev wget build-base openssl-dev
RUN <<EOF
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar -xzf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure --lua-version=5.1
make && make install
luarocks install --lua-version=5.1 lapis
luarocks install --lua-version=5.1 luabitop
luarocks install --lua-version=5.1 lua-resty-http
luarocks install --lua-version=5.1 lua-cjson
luarocks list
export PATH="/usr/local/lib/luarocks/rocks-5.1:$PATH"
EOF
COPY . /app
WORKDIR /app
EXPOSE 80
CMD ["lapis", "server", "production"]
