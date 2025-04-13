# Odoo 开发环境

此目录包含用于本地开发和测试 Odoo 的配置文件和工具。

## 目录内容

- `odoo_dev.conf`: Odoo 开发环境配置文件
- `requirements.txt.modified`: 修改后的 Python 依赖列表（移除了一些可能导致安装问题的包）
- `mac_odoo_setup_guide.md`: macOS 环境下设置 Odoo 的完整指南
- `start_odoo.sh`: 启动 Odoo 服务的便捷脚本
- `init_db.sh`: 初始化 Odoo 开发环境的脚本
- `reset.sh`: 重置 Odoo 环境（删除数据库和数据目录）的脚本

## 完整设置流程

### 1. 克隆代码库

```bash
git clone https://github.com/your-repo/odoo.git
cd odoo
```

### 2. 创建并激活 Python 虚拟环境

```bash
# 创建虚拟环境
python3 -m venv odoo-venv

# 激活虚拟环境
source odoo-venv/bin/activate
```

### 3. 安装依赖

```bash
# 安装Python依赖
pip install -r requirements.txt

# 如果遇到安装问题，可以尝试使用修改版的依赖列表
pip install -r dev/requirements.txt.modified
```

### 4. 初始化环境

```bash
./dev/init_db.sh
```

### 5. 启动 Odoo 服务

```bash
./dev/start_odoo.sh
```

### 6. 创建数据库

访问 http://localhost:8069 并按照页面引导创建您的第一个数据库。

## 使用方法

### 初始化环境

首次设置开发环境时：

```bash
# 从项目根目录
./dev/init_db.sh

# 或从dev目录
cd dev
./init_db.sh
```

此脚本会创建必要的目录结构，但不会预先创建数据库。首次访问 Odoo 时，系统会自动引导您创建数据库。

### 启动服务

```bash
# 从项目根目录
./dev/start_odoo.sh

# 或从dev目录
cd dev
./start_odoo.sh
```

### 重置环境

当需要清除所有数据并重新开始时：

```bash
# 从项目根目录
./dev/reset.sh

# 或从dev目录
cd dev
./reset.sh
```

重置后，再次访问 http://localhost:8069 时，可以重新创建数据库。

### 访问 Odoo

启动成功后，在浏览器中访问：
http://localhost:8069

首次访问时，系统会引导您创建一个新数据库。

### 数据库管理

访问数据库管理界面：
http://localhost:8069/web/database/manager

管理员密码（Master Password）: `myodoo123`

- **创建数据库**：在数据库管理界面选择"创建数据库"
- **删除数据库**：在数据库管理界面选择"删除数据库"
- **备份数据库**：在数据库管理界面选择"备份数据库"
- **恢复数据库**：在数据库管理界面选择"恢复数据库"

**注意**：数据库操作需要使用管理员密码。当提示输入 master password 时，请使用`myodoo123`。

## 开发流程

1. **初始设置**:

   - 克隆代码库
   - 创建并激活虚拟环境
   - 安装依赖
   - 运行 `./dev/init_db.sh` 初始化环境
   - 启动 Odoo 后通过浏览器创建数据库

2. **日常开发**:

   - 启动服务：`./dev/start_odoo.sh`
   - 访问 http://localhost:8069
   - 开发自定义模块（放在 `addons/` 目录）

3. **环境问题排查**:
   - 遇到无法恢复的错误时：`./dev/reset.sh`
   - 重置后重新访问系统并创建新数据库

## 常见问题

- 如果遇到数据库连接问题，请检查 PostgreSQL 服务是否正在运行
- 首次启动时，需要创建数据库并设置管理员账户
- 开发模式已经在配置中启用，添加了`dev = all`参数
- 会话错误（No such file or directory）通常可以通过重置环境解决
- 确保从正确的目录运行脚本，最好总是从项目根目录运行
- 如果遇到权限问题，检查脚本是否有执行权限：`chmod +x dev/*.sh`
- 如果遇到"Access Denied"错误，请确认使用了正确的管理员密码（myodoo123）
- 创建数据库后无法登录或显示"dbfilter rejects it"错误，检查配置文件中的`db_name`参数
- 如果启动脚本提示"虚拟环境不存在"，请按照"完整设置流程"中的步骤创建并激活虚拟环境
