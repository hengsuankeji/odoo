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
    echo "  # 初始化环境"
    echo "  ./dev/init_db.sh"
    echo ""
    exit 1
fi

# 激活虚拟环境
source odoo-venv/bin/activate

# 启动Odoo服务
./odoo-bin -c dev/odoo_dev.conf 