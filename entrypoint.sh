#!/bin/sh

echo "Generating minimal redis configuration..."
cat <<EOF > /etc/redis.conf
bind 127.0.0.1
protected-mode no
port 6379
daemonize yes
dir /var/lib/redis
EOF

echo "Starting Redis server..."
redis-server /etc/redis.conf

# 等待 2 秒让 Redis 启动
sleep 2

# 验证 Redis 是否正常运行
if redis-cli ping | grep -q "PONG"; then
    echo "SUCCESS: Redis is up and running!"
else
    echo "ERROR: Redis failed to start properly."
    exit 1
fi

echo "Starting Next.js application..."
exec node server.js
