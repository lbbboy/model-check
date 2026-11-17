#!/bin/sh

# 1. 在后台以守护进程模式启动 Redis
redis-server --daemonize yes

# 2. 等待 2 秒确保 Redis 正常初始化
sleep 2

# 3. 验证 Redis 是否可用
if redis-cli ping | grep -q "PONG"; then
    echo "Redis service started successfully inside container."
else
    echo "Error: Redis failed to start."
    exit 1
fi

# 4. 启动 Next.js standalone 服务
exec node server.js
