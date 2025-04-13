#!/bin/bash

# 获取项目根目录的绝对路径
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

# 切换到项目根目录
cd "$PROJECT_ROOT"

# 检查虚拟环境是否存在
if [ ! -d "odoo-venv" ]; then
    echo "错误: 虚拟环境 'odoo-venv' 不存在!"
    echo "请先创建并初始化Python虚拟环境:"
    echo ""
    echo "  # 创建虚拟环境"
    echo "  python3 -m venv odoo-venv"
    echo ""
    echo "  # 激活虚拟环境"
    echo "  source odoo-venv/bin/activate"
    echo ""
    echo "  # 安装依赖"
    echo "  pip install -r requirements.txt"
    echo ""
    exit 1
fi

# 激活虚拟环境
source odoo-venv/bin/activate

# 检查PostgreSQL是否已安装
if ! command -v psql &> /dev/null; then
    echo "错误: PostgreSQL未安装或不在PATH中"
    echo "请安装PostgreSQL并确保'psql'命令可用"
    exit 1
fi

# 创建必要的目录结构（如果不存在）
mkdir -p data
mkdir -p addons

echo "============================================================"
echo "Odoo开发环境准备完成！"
echo "请使用 './dev/start_odoo.sh' 启动Odoo服务"
echo "然后访问 http://localhost:8069 创建您的第一个数据库"
echo "管理员密码(Master Password): myodoo123"
echo "============================================================"

# 以下命令已注释，首次访问时，Odoo会自动引导您创建数据库
# ./odoo-bin -c dev/odoo_dev.conf -i base --stop-after-init 