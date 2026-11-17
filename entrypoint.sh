#!/bin/sh

echo "=========================================="
echo "[Entrypoint] Initializing container services..."
echo "=========================================="

# 1. 创建 Redis 运行目录
mkdir -p /var/lib/redis /var/log/redis

# 2. 生成显式配置文件
cat <<EOF > /etc/redis.conf
bind 127.0.0.1
protected-mode no
port 6379
daemonize no
dir /var/lib/redis
logfile /var/log/redis/redis.log
EOF

echo "[Entrypoint] Starting Redis in background..."
# 改用配置文件的形式启动，并将日志输出
redis-server /etc/redis.conf &

# 3. 等待最多 5 秒让 Redis 准备就绪
echo "[Entrypoint] Waiting for Redis to accept connections..."
i=0
while [ $i -lt 5 ]; do
    if redis-cli ping > /dev/null 2>&1; then
        echo "[Entrypoint] SUCCESS: Redis is up and responding to PING!"
        break
    fi
    i=$((i + 1))
    sleep 1
done

# 4. 再次验证是否成功
if ! redis-cli ping > /dev/null 2>&1; then
    echo "[Entrypoint] ERROR: Redis failed to start within 5 seconds."
    echo "--- Redis Log ---"
    cat /var/log/redis/redis.log 2>/dev/null || echo "No log file found."
    exit 1
fi

echo "=========================================="
echo "[Entrypoint] Starting Next.js application..."
echo "=========================================="

# 5. 启动主应用
exec node server.js
