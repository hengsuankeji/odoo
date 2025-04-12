# Odoo 本地开发与调试指南

本文档提供了如何在本地环境中设置、运行和调试 Odoo v18 项目的详细指南，适用于从 Docker 部署转向本地开发环境的开发者。

## 目录

1. [环境准备](#环境准备)
2. [配置 Odoo](#配置-odoo)
3. [运行 Odoo](#运行-odoo)
4. [调试技巧](#调试技巧)
5. [前端调试](#前端调试)
6. [与 IDE 集成](#与-ide-集成)
7. [模块开发工作流](#模块开发工作流)
8. [常见问题解决](#常见问题解决)

## 环境准备

### 安装 Python

Odoo v18 要求 Python 3.10 或更高版本。

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install python3 python3-pip python3-dev python3-venv python3-wheel
```

**Windows:**
从 [python.org](https://www.python.org/downloads/) 下载并安装 Python 3.10+。

**macOS:**
```bash
brew install python@3.10
```

### 安装 PostgreSQL

**Ubuntu/Debian:**
```bash
sudo apt install postgresql
# 创建数据库用户
sudo -u postgres createuser -s $USER
sudo -u postgres createuser -s odoo
sudo -u postgres psql -c "ALTER USER odoo WITH PASSWORD 'odoo';"
```

**Windows:**
从 [PostgreSQL 官网](https://www.postgresql.org/download/windows/) 下载并安装。

**macOS:**
```bash
brew install postgresql@14
brew services start postgresql@14
# 创建数据库用户
createuser -s odoo
psql -c "ALTER USER odoo WITH PASSWORD 'odoo';"
```

### 安装其他依赖

**Ubuntu/Debian:**
```bash
sudo apt install build-essential libldap2-dev libsasl2-dev \
    libpq-dev libjpeg-dev libyaml-dev libxml2-dev libxslt1-dev \
    node-less npm
```

**Windows:**
安装适当的 C++ 编译器和开发工具，如 Visual C++ Build Tools。

**macOS:**
```bash
brew install libjpeg libxml2 libxslt libyaml node
```

### 创建并激活虚拟环境

```bash
# 在项目根目录下
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# 或 venv\Scripts\activate.bat  # Windows
```

### 安装项目依赖

```bash
pip install -r requirements.txt
```

## 配置 Odoo

### 创建配置文件

可以基于项目中已有的 `odoo.conf` 文件进行修改，或创建新的配置文件 `odoo-dev.conf`:

```ini
[options]
; 管理员密码，用于数据库管理
admin_passwd = admin

; 数据库配置
db_host = localhost
db_port = 5432
db_user = odoo
db_password = odoo
db_name = mycompany

; 模块路径 - 根据实际项目结构调整
addons_path = ./addons,./odoo/addons

; 开发者设置
dev = all
debug = True
workers = 0
max_cron_threads = 1

; 日志配置
logfile = ./odoo-dev.log
log_level = debug
log_handler = odoo.tools.convert:DEBUG

; 其他设置
list_db = True
without_demo = False
```

## 运行 Odoo

### 创建/更新数据库

```bash
# 创建新数据库
./odoo-bin -c odoo-dev.conf -d mycompany --without-demo=all --stop-after-init

# 或更新现有数据库
./odoo-bin -c odoo-dev.conf -d mycompany -u base --stop-after-init
```

### 启动开发服务器

```bash
# 开发模式启动
./odoo-bin -c odoo-dev.conf -d mycompany --dev=all
```

常用启动参数:

- `-c odoo-dev.conf`: 指定配置文件
- `-d mycompany`: 指定数据库名称
- `--dev=all`: 启用所有开发者功能
  - `--dev=xml`: 仅启用 XML 热重载
  - `--dev=js`: 仅启用 JS 资源热重载
- `--limit-time-real=0`: 禁用长操作超时限制（调试时很有用）
- `--log-level=debug`: 设置日志级别
- `--log-handler=odoo.addons.my_module:DEBUG`: 为特定模块设置日志级别
- `-u module_name`: 启动时更新指定模块
- `-i module_name`: 启动时安装指定模块

## 调试技巧

### Python 调试器

在代码中添加断点:

```python
import pdb; pdb.set_trace()
```

或者使用更现代的 `breakpoint()`:

```python
breakpoint()
```

常用 pdb 命令:
- `n`: 执行下一行
- `s`: 进入函数
- `c`: 继续执行直到下一个断点
- `p variable`: 输出变量值
- `l`: 显示当前位置的代码
- `q`: 退出调试器

### 使用日志调试

```python
import logging
_logger = logging.getLogger(__name__)

_logger.debug('详细调试信息: %s', variable)
_logger.info('一般信息: %s', variable)
_logger.warning('警告信息: %s', variable)
_logger.error('错误信息: %s', exception)
```

### 访问 Shell

直接在命令行交互式操作 Odoo:

```bash
./odoo-bin shell -c odoo-dev.conf -d mycompany
```

Shell 环境中的常用操作:

```python
# 获取环境
env = self.env

# 搜索记录
partners = env['res.partner'].search([('name', 'like', 'Tech')])

# 创建记录
new_partner = env['res.partner'].create({
    'name': 'New Partner',
    'email': 'new@example.com',
})

# 更新记录
partners[0].write({'phone': '123456789'})

# 提交事务
env.cr.commit()
```

## 前端调试

### 浏览器开发工具

使用 Chrome/Firefox 开发者工具进行前端调试:
- F12 或 Ctrl+Shift+I 打开开发者工具
- 在 Network 选项卡监控网络请求
- 在 Console 选项卡查看 JavaScript 输出
- 在 Sources/Debugger 选项卡设置断点

### Odoo JavaScript 调试

在 JavaScript 代码中添加:

```javascript
console.log('调试信息:', variable);
console.warn('警告信息');
console.error('错误信息');
console.trace(); // 输出当前调用栈
debugger; // 添加断点
```

### 启用浏览器开发者工具的 Odoo 调试模式

1. 在 URL 后添加 `?debug=1` 参数
2. 或点击登录页面的开发者模式选项
3. 或按 Ctrl+Shift+O 打开开发者菜单

### 使用 Odoo 开发者工具

在启用调试模式后，会出现以下功能：
- 查看视图定义和继承关系
- 编辑视图
- 调试资产束
- 查看字段与记录 XML ID
- 查看 SQL 查询日志

## 与 IDE 集成

### VS Code 配置

创建 `.vscode/launch.json` 文件:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Odoo",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/odoo-bin",
            "args": [
                "-c",
                "${workspaceFolder}/odoo-dev.conf",
                "-d",
                "mycompany",
                "--dev=all"
            ],
            "console": "integratedTerminal",
            "justMyCode": false
        },
        {
            "name": "Odoo Shell",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/odoo-bin",
            "args": [
                "shell",
                "-c",
                "${workspaceFolder}/odoo-dev.conf",
                "-d",
                "mycompany"
            ],
            "console": "integratedTerminal",
            "justMyCode": false
        }
    ]
}
```

创建 `.vscode/settings.json` 文件:

```json
{
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "python.linting.pylintArgs": [
        "--disable=C0111",
        "--disable=C0103"
    ],
    "python.formatting.provider": "black",
    "python.formatting.blackArgs": [
        "--line-length=100"
    ],
    "[python]": {
        "editor.formatOnSave": true
    },
    "files.watcherExclude": {
        "**/.git/**": true,
        "**/node_modules/**": true,
        "**/venv/**": true
    }
}
```

### PyCharm 配置

1. 打开项目目录
2. 配置 Python 解释器:
   - 文件 > 设置 > 项目 > Python 解释器
   - 选择之前创建的虚拟环境
3. 创建运行配置:
   - 运行 > 编辑配置 > 添加新配置 > Python
   - 脚本路径: 选择 `odoo-bin`
   - 参数: `-c odoo-dev.conf -d mycompany --dev=all`
   - 工作目录: 项目根目录

## 模块开发工作流

### 创建新模块

使用脚手架创建新模块:

```bash
./odoo-bin scaffold my_module ./addons
```

或手动创建模块基本结构:

```
my_module/
├── __init__.py
├── __manifest__.py
├── controllers/
│   ├── __init__.py
│   └── controllers.py
├── models/
│   ├── __init__.py
│   └── models.py
├── security/
│   └── ir.model.access.csv
├── views/
│   └── views.xml
└── static/
    ├── description/
    │   └── icon.png
    └── src/
        ├── js/
        └── scss/
```

### 模块清单文件

`__manifest__.py` 示例:

```python
{
    'name': 'My Module',
    'version': '1.0',
    'category': 'Custom',
    'summary': 'Module Summary',
    'description': """
Detailed description of the module.
    """,
    'author': 'Your Name',
    'website': 'https://www.example.com',
    'depends': ['base', 'web'],
    'data': [
        'security/ir.model.access.csv',
        'views/views.xml',
    ],
    'assets': {
        'web.assets_backend': [
            'my_module/static/src/js/my_component.js',
            'my_module/static/src/scss/my_style.scss',
        ],
    },
    'installable': True,
    'application': False,
    'auto_install': False,
    'license': 'LGPL-3',
}
```

### 模块安装与升级

安装新模块:

```bash
./odoo-bin -c odoo-dev.conf -d mycompany -i my_module
```

升级已存在的模块:

```bash
./odoo-bin -c odoo-dev.conf -d mycompany -u my_module
```

多个模块:

```bash
./odoo-bin -c odoo-dev.conf -d mycompany -u my_module,other_module
```

### 修改数据库结构

当修改模型字段时，需要更新模块:

```bash
./odoo-bin -c odoo-dev.conf -d mycompany -u my_module
```

对于复杂修改，可能需要编写迁移脚本:

```
my_module/
└── migrations/
    └── 18.0.1.0/
        ├── pre-migration.py
        └── post-migration.py
```

## 常见问题解决

### 无法连接数据库

检查配置:
- 确认 PostgreSQL 服务正在运行
- 验证数据库用户名和密码
- 检查数据库主机和端口
- 验证防火墙设置

### 模块找不到或无法加载

- 检查 `addons_path` 配置
- 确保模块结构正确
- 检查 `__init__.py` 文件是否正确导入子模块
- 检查模块依赖是否已安装

### 资源未更新

清除缓存:
- 使用 `--dev=all` 参数启动服务器
- 或手动清除 `.pyc` 文件和 `__pycache__` 目录
- 在浏览器中清除缓存和 cookies

### 前端资源问题

- 检查浏览器控制台错误
- 验证 `__manifest__.py` 中的 `assets` 配置
- 重新生成资源束: `-u web` 更新 web 模块

### 数据库迁移问题

- 备份您的数据库
- 使用 `-u all` 更新所有模块
- 检查日志中的迁移错误
- 如有严重问题，考虑恢复备份 