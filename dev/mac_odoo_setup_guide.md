# macOS 环境下 Odoo 本地开发环境搭建指南

## 环境准备

### 系统要求

- macOS 系统 (本指南基于 macOS Sonoma 14+)
- 推荐 Python 3.10 或更高版本
- PostgreSQL 12 或更高版本
- Git

## 安装步骤

### 1. 安装必要的软件包

使用 Homebrew 安装所需依赖：

```bash
# 安装Python 3.10（如果尚未安装）
brew install python@3.10

# 安装PostgreSQL（如果尚未安装）
brew install postgresql@14

# 启动PostgreSQL服务
brew services start postgresql@14

# 安装其他依赖
brew install libpq
brew install node
brew install git
```

### 2. 设置 Python 环境

确保使用 Python 3.10 作为默认版本：

```bash
# 在~/.zshrc添加以下内容设置Python 3.10为默认版本
export PATH="/opt/homebrew/opt/python@3.10/libexec/bin:$PATH"
alias python=python3.10
alias pip=pip3.10

# 使配置生效
source ~/.zshrc
```

### 3. 克隆 Odoo 代码库

```bash
git clone https://github.com/odoo/odoo.git
cd odoo
```

### 4. 创建并激活虚拟环境

```bash
# 创建虚拟环境
python -m venv odoo-venv

# 激活虚拟环境
source odoo-venv/bin/activate
```

### 5. 安装 Python 依赖

```bash
# 安装依赖
pip install -r requirements.txt
```

### 6. 配置 PostgreSQL 数据库

```bash
# 创建odoo数据库用户（密码可自定义）
createuser -s -P odoo

# 创建数据库
createdb -O odoo odoo
```

### 7. 配置 Odoo

创建或修改 odoo.conf 配置文件：

```
[options]
; 这是示例配置文件，可根据需要自定义调整
addons_path = ./addons
data_dir = ./data
db_host = localhost
db_port = 5432
db_user = odoo
db_password = 你的密码
db_name = odoo
http_port = 8069
```

### 8. 启动 Odoo 服务

```bash
# 使用配置文件启动Odoo
./odoo-bin -c odoo.conf
```

或者不使用配置文件直接启动：

```bash
./odoo-bin --addons-path=addons --db-host=localhost --db-port=5432 --db-user=odoo --db-password=你的密码
```

### 9. 访问 Odoo

启动成功后，打开浏览器访问：
http://localhost:8069

首次访问时，需要创建数据库并设置管理员账号。

## 开发调试技巧

### 开发者模式

登录后，激活开发者模式：

- 点击 Settings > Activate the developer mode

### 常用开发调试参数

```bash
# 开启开发者模式启动
./odoo-bin -c odoo.conf --dev=all

# 只加载特定模块
./odoo-bin -c odoo.conf -i module_name

# 更新特定模块
./odoo-bin -c odoo.conf -u module_name

# 指定日志级别
./odoo-bin -c odoo.conf --log-level=debug
```

### 常见问题排查

1. **依赖安装失败**: 检查是否安装了所有系统依赖，可能需要安装额外的编译工具

   ```bash
   brew install libxml2 libxslt zlib libjpeg libpng freetype
   ```

2. **端口冲突**: 如果 8069 端口被占用，可修改配置中的 http_port 或使用命令行参数指定

   ```bash
   ./odoo-bin -c odoo.conf --http-port=8080
   ```

3. **数据库连接问题**: 确认 PostgreSQL 正在运行且配置正确
   ```bash
   brew services list | grep postgresql
   psql -U odoo -d odoo -h localhost
   ```

## 更新和维护

### 更新 Odoo 代码

```bash
git pull origin master  # 或你当前使用的分支
```

### 更新 Python 依赖

```bash
pip install -r requirements.txt --upgrade
```

### 重置数据库（谨慎操作）

```bash
dropdb odoo
createdb -O odoo odoo
```

## 参考资源

- [Odoo 官方文档](https://www.odoo.com/documentation/18.0/)
- [Odoo GitHub 仓库](https://github.com/odoo/odoo)
- [Odoo 社区论坛](https://www.odoo.com/forum/help-1)
