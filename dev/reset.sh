#!/bin/bash

# 获取项目根目录的绝对路径
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

# 切换到项目根目录
cd "$PROJECT_ROOT"

# 检查虚拟环境是否存在
if [ ! -d "odoo-venv" ]; then
    echo "警告: 虚拟环境 'odoo-venv' 不存在! 仅执行数据清理操作。"
fi

# 检查PostgreSQL命令是否可用
if ! command -v dropdb &> /dev/null || ! command -v createdb &> /dev/null; then
    echo "错误: PostgreSQL命令(dropdb/createdb)不可用"
    echo "请确保PostgreSQL已安装且在PATH中"
    exit 1
fi

# 提示用户确认
echo "警告: 这将删除数据库和数据目录! 是否继续? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # 删除数据库
    dropdb odoo 2>/dev/null || echo "数据库odoo不存在，跳过删除"

    # 清空数据目录但保留目录结构
    if [ -d "./data" ]; then
        find ./data -mindepth 1 -delete
    fi

    # 重新创建数据库
    createdb -O odoo odoo 2>/dev/null || echo "警告: 无法创建数据库，请检查PostgreSQL用户权限"

    echo "环境已重置。运行 ./dev/init_db.sh 以初始化开发环境。"
    echo "然后访问 http://localhost:8069 创建您的数据库。"
else
    echo "操作已取消"
fi 