#!/bin/bash
# 部署博客的快捷脚本

git add .

# 如果有传入参数，就用第一个参数作为提交信息；否则使用默认信息
if [ -n "$1" ]; then
    commit_message="$1"
else
    commit_message="update blog"
fi

git commit -m "$commit_message"
git push