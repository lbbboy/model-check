#!/bin/sh

echo "Starting Redis server..."
# 以安全且稳定的方式启动 Redis（Alpine 标准做法）
redis-server --protected-mode no &

# 等待 3 秒让 Redis 完全启动
sleep 3

# 检查 Redis 进程是否存活
if pgrep redis-server > /dev/null; then
    echo "Redis server is running."
else
    echo "Error: Redis failed to start."
    exit 1
fi

# 测试 Redis 连通性
redis-cli ping

echo "Starting Next.js application..."
# 启动你的 Next.js standalone 服务
exec node server.js
