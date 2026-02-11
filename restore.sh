#!/bin/bash
# OpenClaw 一键恢复脚本
# 用法: ./restore.sh <backup_folder>

set -e

BACKUP_DIR="${1:-./}"
TIMESTAMP=$(ls -d ${BACKUP_DIR}/OpenClaw_* 2>/dev/null | tail -1 | grep -o 'OpenClaw_[0-9]*_[0-9]*')

if [ -z "$TIMESTAMP" ]; then
    echo "❌ 未找到备份文件夹"
    echo "用法: ./restore.sh /path/to/backup"
    exit 1
fi

BACKUP_DIR="${BACKUP_DIR}/OpenClaw_${TIMESTAMP}"
echo "🚀 开始恢复 OpenClaw 备份..."
echo "📁 备份目录: $BACKUP_DIR"

# 1. 恢复 OpenClaw 核心配置
echo ""
echo "📦 恢复 1/4: OpenClaw 核心配置..."
cd /Users/yizhi/.openclaw
tar -xzf "$BACKUP_DIR/openclaw_core.tar.gz"

# 2. 恢复 Skills
echo ""
echo "📦 恢复 2/4: Skills (第二大脑 + 模型故障转移)..."
cd /Users/yizhi/.openclaw/workspace/skills
tar -xzf "$BACKUP_DIR/skills_all.tar.gz"

# 3. 恢复 Obsidian 知识库
echo ""
echo "📦 恢复 3/4: Obsidian 知识库..."
cd /Users/yizhi/.openclaw/workspace
tar -xzf "$BACKUP_DIR/obsidian_knowledge_base.tar.gz"

# 4. 恢复 Workspace 文件
echo ""
echo "📦 恢复 4/4: Workspace 其他文件..."
tar -xzf "$BACKUP_DIR/workspace_files.tar.gz"

echo ""
echo "✅ 恢复完成！"
echo ""
echo "📋 下一步操作:"
echo "1. 重启 OpenClaw: openclaw gateway restart"
echo "2. 验证配置: openclaw status"
echo "3. 检查模型: openclaw model status"
echo ""
