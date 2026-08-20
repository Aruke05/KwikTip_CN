# KwikTip 简体中文维护版

本分支基于上游 [postblink/KwikTip](https://github.com/postblink/KwikTip)，为简体中文（`zhCN`）客户端维护界面本地化。

## 已汉化内容

- 插件标题与说明
- 设置界面、按钮、选项及悬浮提示
- `/kwik` 命令帮助、状态与调试消息
- HUD 固定标签、预览文本和个人备注界面
- 当前第 2 赛季全部 8 个史诗钥石地下城的首领攻略正文
- 魔导师平台全部首领及已定义区域攻略正文

攻略翻译保留英文技能标识并提供中文操作说明，方便和游戏施法条及上游资料核对。尚未校对的副本自动回退到上游英文；这里不会凭空增加未经实测的动态优先级或机制。首领战检测仍使用 Blizzard 的稳定 `encounterID`。

## 安装

1. 下载仓库 ZIP 并解压。
2. 将插件目录命名为 `KwikTip`。
3. 把整个目录复制到：

   ```text
   World of Warcraft\_retail_\Interface\AddOns\KwikTip
   ```

4. 重载游戏界面：`/reload`。
5. 输入 `/kwik` 打开中文设置。

## 中文客户端验证

在地下城内输入 `/kwik debug` 可查看副本、地图、子区域与职责检测状态。若某个区域未显示提示：

1. 输入 `/kwik debuglog` 开启日志；
2. 进入问题区域并等待区域切换完成；
3. 退出游戏，让 SavedVariables 写入磁盘；
4. 提交问题，并附上 `KwikTip.lua` 中对应的 `instanceID`、`mapID` 与 `subzone` 记录。

只有能由中文客户端运行时日志可靠确认的子区域别名才会加入维护版。

## 上游同步

本仓库保留 `upstream` 远程。维护时先同步上游，再重新运行测试：

```powershell
git fetch upstream --tags
git rebase upstream/master
python -m unittest tests.test_zhcn_static
lua5.1 tests/test_localization.lua
```

Lua 运行时测试会覆盖英语回退、德语兼容和中文界面；Python 静态测试会检查中文键完整性、格式化占位符及 TOC 加载顺序。
