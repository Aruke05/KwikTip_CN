# KwikTip_CN 独立简体中文维护版

`KwikTip_CN` 基于上游 [postblink/KwikTip](https://github.com/postblink/KwikTip)，但使用独立的插件目录、TOC、SavedVariables 和发布包。它不会再冒充原版 `KwikTip`，也不携带原版在 CurseForge、Wago 或 WoWInterface 的项目 ID。

当前版本：`3.4.0-cn.9`，基于上游 `v3.4.0`。

## 自定义富文本提示

此版本不再显示随插件附带的副本攻略正文。副本、首领、区域和 `encounterID` 数据仅用于判断当前位置；HUD 正文全部来自你自己的配置。

输入 `/kwikcn` 打开设置，然后选择左侧的 **文本编辑**：

1. 在“大秘境”菜单中选择当前赛季的 8 个大秘境副本；
2. 选择“副本总览”、首领或已定义区域；
3. 使用颜色、坦克/治疗/输出/打断图标、项目符号和换行工具，或直接输入 WoW 富文本标记；
4. 在下方实时预览中确认效果，然后点击“保存文本”。

内容保存在 `KwikTipCNDB.customTips`，插件更新不会覆盖。空白条目不会回退到原版攻略。

HUD 左下角的铅笔按钮可直接编辑当前正在显示的副本总览、首领或区域攻略。悬浮编辑器与设置页使用同一份数据，并同样提供颜色、职责图标、项目符号、换行和实时预览；按 `Ctrl+Enter` 或点击“保存”即可写入。

## 已汉化内容

- 插件标题与说明
- 设置界面、按钮、选项及悬浮提示
- `/kwikcn`、`/kwik` 命令帮助、状态与调试消息
- HUD 固定标签、预览文本和个人备注界面
- 当前第 2 赛季全部 8 个史诗钥石地下城的可编辑条目
- 设置页和悬浮窗中的大秘境副本名、首领名（直接读取 Blizzard 中文客户端数据）
- 富文本工具栏、实时预览与保存状态

首领战检测仍使用 Blizzard 的稳定 `encounterID`。插件不会提供或回退到内置攻略正文，所有操作提示均由用户自行编写。

## 安装

1. 下载仓库 ZIP 并解压。
2. 确认插件目录名为 `KwikTip_CN`。
3. 将整个目录复制到：

   ```text
   World of Warcraft\_retail_\Interface\AddOns\KwikTip_CN
   ```

4. 删除或禁用旧的 `AddOns\KwikTip`，避免两个版本同时加载。
5. 完全退出并重新启动游戏，在角色选择界面启用 `KwikTip 中文版`。
6. 输入 `/kwikcn`（兼容 `/kwik`）打开中文设置。

配置保存在独立文件 `WTF\Account\<账号>\SavedVariables\KwikTip_CN.lua`，变量名为 `KwikTipCNDB`，不会修改原版配置。

## 中文客户端验证

在地下城内输入 `/kwikcn debug` 可查看副本、地图、子区域与职责检测状态。若某个区域未显示提示：

1. 输入 `/kwikcn debuglog` 开启日志；
2. 进入问题区域并等待区域切换完成；
3. 退出游戏，让 SavedVariables 写入磁盘；
4. 在 [KwikTip_CN issues](https://github.com/Aruke05/KwikTip_CN/issues) 提交问题，并附上 `KwikTip_CN.lua` 中对应的 `instanceID`、`mapID` 与 `subzone` 记录。

只有能由中文客户端运行时日志可靠确认的子区域别名才会加入维护版。

## 上游同步

仓库保留 `upstream` 远程。同步时先在独立分支合并上游，再保留本版的独立身份字段：`KwikTip_CN.toc`、`KwikTipCNDB`、`package-as: KwikTip_CN`，以及不含上游分发平台项目 ID。

```powershell
git fetch upstream --tags
git merge upstream/master
python -m unittest tests.test_zhcn_static
lua5.1 tests/test_localization.lua
```

Lua 运行时测试覆盖英语回退、德语兼容和中文界面；Python 静态测试检查中文键完整性、格式化占位符、TOC 加载顺序与独立插件身份。
