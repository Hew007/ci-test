#!/bin/sh

# 出现非0错误 终止脚本
set -e

# 打印当前的工作路径
pwd
ls
# 定义远程仓库地址变量
remote=$(git config remote.origin.url)

echo 'remote is: '$remote

# 新建一个发布项目的目录
mkdir git-pages-rp
cd git-pages-rp
# 创建的一个新的仓库
# 设置发布的用户名与邮箱
git config --global user.email "$GH_EMAIL" >/dev/null 2>&1
git config --global user.name "$GH_NAME" >/dev/null 2>&1
# 初始化一个临时的git仓库
git init
# 拉取远程代码
git remote add --fetch origin "$remote"
# 打印账户信息和构建目录
echo 'email is: '$GH_EMAIL
echo 'name is: '$GH_NAME
echo 'sitesource is: '$STATIC_SOURCE

# 切换gh-pages分支
# 验证git 是否存在gh-pages分支
if git rev-parse --verify origin/gh-pages >/dev/null 2>&1; then
  # 检出此分支
  git checkout gh-pages
  # 删除掉旧的文件内容
  git rm -rf .
else
  git checkout --orphan gh-pages
fi

# 把构建好的文件目录给拷贝进来
cp -a "../${STATIC_SOURCE}/." .

ls -la

# 把所有的文件添加到git
git add -A
# 添加一条提交内容
git commit --allow-empty -m "Deploy to GitHub pages [ci skip]"
# 推送文件
git push --force --quiet origin gh-pages
# 资源回收，删除临时分支与目录
cd ..
rm -rf git-pages-rp

echo "Delpoy Sucessful"
