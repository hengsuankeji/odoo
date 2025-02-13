[![Build Status](https://runbot.odoo.com/runbot/badge/flat/1/master.svg)](https://runbot.odoo.com/runbot)
[![Tech Doc](https://img.shields.io/badge/master-docs-875A7B.svg?style=flat&colorA=8F8F8F)](https://www.odoo.com/documentation/master)
[![Help](https://img.shields.io/badge/master-help-875A7B.svg?style=flat&colorA=8F8F8F)](https://www.odoo.com/forum/help-1)
[![Nightly Builds](https://img.shields.io/badge/master-nightly-875A7B.svg?style=flat&colorA=8F8F8F)](https://nightly.odoo.com/)

## 本地 Docker 开发环境搭建

### 前置要求

- 安装 [Docker](https://www.docker.com/get-started)
- 安装 [Docker Compose](https://docs.docker.com/compose/install/)

### 构建 Docker 镜像

1. 在项目根目录下执行以下命令构建 Docker 镜像：

```bash
# 构建镜像（注意最后的点 . 不要忘记）
docker build -t ultron:1.0 .
```

### 启动项目

1. 进入 dockerrun 目录：

```bash
cd dockerrun
```

2. 启动服务：

```bash
docker compose up -d
```

服务启动后：

- Odoo 网页界面访问地址：http://localhost:8069
- 默认数据库配置：
  - 数据库：postgres
  - 用户名：odoo
  - 密码：123456
  - 管理员密码：myodoo123

### 常用命令

```bash
# 查看容器日志
docker compose logs -f

# 停止服务
docker compose down

# 重启服务
docker compose restart

# 重新构建并启动（当 Dockerfile 或配置发生变化时）
docker compose down && docker compose up -d
```

### 目录结构说明

- `/opt/odoo/odoo/addons`：Odoo 核心模块目录
- `/opt/odoo/addons`：Odoo 标准业务模块目录
- `/mnt/extra-addons`：自定义模块目录（可通过 dockerrun/extra-addons 目录添加自定义模块）

## Odoo

Odoo is a suite of web based open source business apps.

The main Odoo Apps include an <a href="https://www.odoo.com/page/crm">Open Source CRM</a>,
<a href="https://www.odoo.com/app/website">Website Builder</a>,
<a href="https://www.odoo.com/app/ecommerce">eCommerce</a>,
<a href="https://www.odoo.com/app/inventory">Warehouse Management</a>,
<a href="https://www.odoo.com/app/project">Project Management</a>,
<a href="https://www.odoo.com/app/accounting">Billing &amp; Accounting</a>,
<a href="https://www.odoo.com/app/point-of-sale-shop">Point of Sale</a>,
<a href="https://www.odoo.com/app/employees">Human Resources</a>,
<a href="https://www.odoo.com/app/social-marketing">Marketing</a>,
<a href="https://www.odoo.com/app/manufacturing">Manufacturing</a>,
<a href="https://www.odoo.com/">...</a>

Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get
a full-featured <a href="https://www.odoo.com">Open Source ERP</a> when you install several Apps.

## Getting started with Odoo

For a standard installation please follow the <a href="https://www.odoo.com/documentation/master/administration/install/install.html">Setup instructions</a>
from the documentation.

To learn the software, we recommend the <a href="https://www.odoo.com/slides">Odoo eLearning</a>, or <a href="https://www.odoo.com/page/scale-up-business-game">Scale-up</a>, the <a href="https://www.odoo.com/page/scale-up-business-game">business game</a>. Developers can start with <a href="https://www.odoo.com/documentation/master/developer/howtos.html">the developer tutorials</a>
